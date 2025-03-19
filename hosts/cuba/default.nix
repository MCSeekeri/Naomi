{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  network-status = pkgs.writeShellScriptBin "network-status" ''
    export PATH=${
      lib.makeBinPath (
        with pkgs;
        [
          iproute2
          coreutils
          gnugrep
          nettools
          gum
        ]
      )
    }
    set -efu -o pipefail
    msgs=()
    if [[ -e /var/shared/qrcode.utf8 ]]; then
      qrcode=$(gum style --border-foreground 240 --border normal "$(< /var/shared/qrcode.utf8)")
      msgs+=("$qrcode")
    fi
    network_status="Root 密码: $(cat /var/shared/root-password)
    本地网络地址:
    $(ip -brief -color addr | grep -v 127.0.0.1)
    $([[ -e /var/shared/onion-hostname ]] && echo "Onion 地址: $(cat /var/shared/onion-hostname)" || echo "Onion 地址: 等待 tor 网络启动...")
    $([[ -e /var/shared/bore.log ]] && grep -q 'listening at bore.pub' /var/shared/bore.log && echo "Bore 地址: bore.pub:$(grep -oP 'listening at bore.pub:\K\d+' /var/shared/bore.log | tail -1)" || echo "Bore 地址: 连接中...")
    Multicast DNS: $(hostname).local"
    network_status=$(gum style --border-foreground 240 --border normal "$network_status")
    msgs+=("$network_status")
    msgs+=("按 'Ctrl-C' 进入控制台")

    gum join --vertical "''${msgs[@]}"
  '';
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
    # 需要用 modulesPath 避免纯评估模式出错，大概
    inputs.stylix.nixosModules.stylix
    ../../modules/Core/ssh.nix
    ../../modules/Core/kmscon.nix
    ../../modules/Core/mDNS.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64
  services = {
    kmscon = {
      autologinUser = lib.mkForce "root";
      fonts = lib.mkForce [
        {
          name = "FiraCode Nerd Font Mono";
          package = pkgs.fira-code-nerdfont;
        }
        {
          # 一个中文字体的体积比一堆工具加起来还大，难办……
          name = "Noto Sans CJK SC";
          package = pkgs.noto-fonts-cjk-sans;
        }
      ];
      extraConfig = lib.mkForce "font-size=12";
    };
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
    tor = {
      enable = true;
      relay.onionServices.hidden-ssh = {
        version = 3;
        map = [
          {
            port = 22;
            target.port = 22;
          }
        ];
      };
      client.enable = true;
    };
  };

  # 网络配置
  networking = {
    hostName = "cuba"; # 主机名，设置好之后最好不要修改
    tempAddresses = "disabled";
    useNetworkd = true;
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
          Settings.AutoConnect = true;
        };
      };
    };
  };

  system = {
    stateVersion = "24.11";
    activationScripts.root-password = ''
      mkdir -p /var/shared
      cat /dev/urandom | tr -dc 'A-HJ-KMNP-Z2-9' | fold -w 4 | head -n 4 | paste -sd "-" - > /var/shared/root-password
      echo "root:$(cat /var/shared/root-password)" | chpasswd
    '';
  };

  boot = {
    initrd.systemd.emergencyAccess = true;
    supportedFilesystems = [
      "ext4"
      "btrfs"
      "f2fs"
      "ntfs"
      "vfat"
      "xfs"
    ];
    kernelParams = [
      "nouveau.modeset=0"
      "console=tty0"
      "console=ttyS0,115200" # 串口调试
      "zswap.enabled=1"
      "zswap.max_pool_percent=50"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
    ];
  };

  environment.systemPackages = [
    pkgs.nixos-install-tools
    pkgs.jq
    pkgs.rsync
    pkgs.disko
    pkgs.bore-cli
    pkgs.geph.cli
    pkgs.clash-rs
    pkgs.proxychains-ng
    pkgs.dae
    pkgs.busybox
    pkgs.bind
    pkgs.ripgrep
    pkgs.btop
    pkgs.libressl
    pkgs.python3Minimal
    pkgs.progress
    pkgs.tmux
    pkgs.file
    network-status
  ];

  stylix = {
    enable = true;
    targets = {
      console.enable = true;
      grub.enable = true;
      plymouth.enable = true;
      fish.enable = true;
      kmscon.enable = true;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  };

  # https://github.com/NixOS/nixpkgs/issues/219239
  programs = {
    bash.interactiveShellInit = ''
      watch --no-title --color ${network-status}/bin/network-status
    '';
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

  nix = {
    settings = {
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
        "https://mirror.sjtu.edu.cn/nix-channels/store?priority=2"
        "https://cache.nixos.org/?priority=3"
        "https://cache.garnix.io?priority=4"
        "https://nix-community.cachix.org?priority=5"
        "https://numtide.cachix.org?priority=6"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" ];
      connect-timeout = 20;
      http-connections = 64;
      max-substitution-jobs = 32; # 加速下载
      max-free = 5 * 1024 * 1024 * 1024;
      min-free = 1024 * 1024 * 1024;
      builders-use-substitutes = true;
    };
  };

  systemd = {
    tmpfiles.rules = [ "d /var/shared 0777 root root - -" ];
    services = {
      bore-tunnel = {
        description = "Bore tunnel service";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.bore-cli}/bin/bore local 22 --to bore.pub";
          Restart = "always";
          RestartSec = 30;
          StandardOutput = "file:/var/shared/bore.log";
          StandardError = "journal";
          User = "root";
        };
      };
      announce = {
        after = [
          "tor.service"
          "bore-tunnel.service"
          "network-online.target"
        ];
        wants = [
          "tor.service"
          "bore-tunnel.service"
          "network-online.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = pkgs.writeShellScript "announce-hidden-service" ''
            set -efu
            export PATH=${
              lib.makeBinPath (
                with pkgs;
                [
                  iproute2
                  coreutils
                  jq
                  qrencode
                  gnugrep
                ]
              )
            }

            until test -e ${config.services.tor.settings.DataDirectory}/onion/hidden-ssh/hostname; do
              echo "Waiting for Onion address..."
              sleep 1
            done

            until grep -q 'listening at bore.pub' /var/shared/bore.log; do
              echo "Waiting for bore address..."
              sleep 1
            done

            onion_hostname=$(cat ${config.services.tor.settings.DataDirectory}/onion/hidden-ssh/hostname)
            echo "$onion_hostname" > /var/shared/onion-hostname
            bore_address=$(grep -oP 'listening at bore.pub:\K\d+' /var/shared/bore.log | tail -1)
            local_addrs=$(ip -json addr | jq '[map(.addr_info) | flatten | .[] | select(.scope == "global") | .local]')
            jq -nc \
              --arg password "$(cat /var/shared/root-password)" \
              --arg onion_address "$onion_hostname" \
              --argjson local_addrs "$local_addrs" \
              --arg bore_address "bore.pub:$bore_address" \
              '{ pass: $password, tor: $onion_address, addrs: $local_addrs, bore: $bore_address }' \
              > /var/shared/login.json

            cat /var/shared/login.json | qrencode -s 2 -m 2 -t utf8 -o /var/shared/qrcode.utf8
          '';
          PrivateTmp = "true";
          User = "tor";
          Type = "oneshot";
        };
      };
    };
  };
  isoImage.squashfsCompression = "zstd"; # zstd 快，xz 更小，没有银弹……
}

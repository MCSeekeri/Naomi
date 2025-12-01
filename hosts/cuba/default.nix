{
  config,
  lib,
  pkgs,
  inputs,
  self,
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
    # "${modulesPath}/installer/cd-dvd/channel.nix"
    # 需要用 modulesPath 避免纯评估模式出错，大概
    inputs.stylix.nixosModules.stylix
    "${self}/modules/Core/avahi.nix"
    "${self}/modules/Core/ssh.nix"
    "${self}/modules/Core/kmscon.nix"
  ];
  nixpkgs = {
    hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64
    overlays = [
      self.overlays.default
      (_final: prev: {
        cifs-utils = prev.cifs-utils.overrideAttrs (oldAttrs: {
          buildInputs = builtins.filter (x: x != prev.samba) oldAttrs.buildInputs; # 剔除掉 samba 依赖
        });
      })
    ];
  };
  services = {
    kmscon = {
      autologinUser = lib.mkForce "root";
      fonts = lib.mkForce [
        {
          # 一个中文字体的体积比一堆工具加起来还大，难办……
          package = pkgs.maple-mono.Normal-CN;
          name = "Maple Mono SC NF";
        }
      ];
      extraConfig = lib.mkForce "font-size=12";
    };
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
    nscd.enableNsncd = true;
    fwupd.enable = true;
  };

  # 网络配置
  networking = {
    hostName = "cuba"; # 主机名，设置好之后最好不要修改
    tempAddresses = "disabled";
    useNetworkd = true;
    wireless = {
      enable = false;
      userControlled.enable = true;
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
    activationScripts.root-password = ''
      mkdir -p /var/shared
      cat /dev/urandom | tr -dc 'A-HJ-KMNP-Y3-9' | fold -w 4 | head -n 4 | paste -sd "-" - > /var/shared/root-password
      echo "root:$(cat /var/shared/root-password)" | chpasswd
    '';
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 70;
  };

  boot = {
    tmp.cleanOnBoot = true;
    initrd.systemd.emergencyAccess = true;
    supportedFilesystems = [
      "ext4"
      "exfat"
      "ext2"
    ];
    kernelParams = [
      "nouveau.modeset=0"
      "console=ttyS0,115200" # 串口调试
      "zswap.zpool=zsmalloc"
      "boot.shell_on_fail"
    ];
  };
  services.samba.enable = false;
  environment = {
    systemPackages = [
      pkgs.disko
      pkgs.bore-cli
      pkgs.geph
      pkgs.clash-rs
      pkgs.proxychains-ng
      pkgs.dae
      pkgs.bind
      pkgs.ripgrep
      pkgs.btop
      pkgs.progress
      pkgs.tmux
      pkgs.file
      pkgs.nh
      pkgs.sbctl
      network-status
    ];
    enableAllTerminfo = true;
  };

  stylix = {
    enable = true;
    autoEnable = true;
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

  users.users.root = {
    shell = pkgs.bash; # 非 POSIX 兼容 Shell 会导致 nixos-anywhere 出问题
  };

  security.sudo.enable = false;

  nix = {
    settings = {
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
        "https://cache.nixos.org?priority=3"
        "https://nix-community.cachix.org?priority=4"
        "https://numtide.cachix.org?priority=5"
        "https://cache.garnix.io?priority=6"
        "https://cache.lix.systems?priority=7"
        "https://nix-gaming.cachix.org?priority=8"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" ];
      connect-timeout = 5;
      http-connections = 64;
      max-substitution-jobs = 32; # 加速下载
      max-free = 3000 * 1024 * 1024;
      min-free = 512 * 1024 * 1024;
      log-lines = 25;
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
}

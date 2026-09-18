{
  lib,
  pkgs,
  inputs,
  self,
  modulesPath,
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
          net-tools
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
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    inputs.stylix.nixosModules.stylix
    "${self}/modules/Core/avahi.nix"
    "${self}/modules/Core/ssh.nix"
    "${self}/modules/Core/nix.nix"
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
  nix.settings.auto-optimise-store = false;
  services = {
    kmscon = {
      enable = true;
      config = {
        font-name = "Maple Mono Normal CN";
        font-size = 12;
      };
    };
    getty.autologinUser = lib.mkForce "root";
    openssh.settings.PermitRootLogin = lib.mkForce "yes";
    fail2ban.enable = lib.mkForce false;
    nscd.enableNsncd = true;
  };
  fonts = {
    fontconfig.enable = true;
    packages = [ pkgs.maple-mono.Normal-CN ];
  };

  documentation.enable = lib.mkOverride 50 false;
  isoImage.squashfsCompression = "zstd";

  # 网络配置
  networking = {
    hostName = "cuba"; # 主机名，设置好之后最好不要修改
    tempAddresses = "disabled";
    useNetworkd = true;
    wireless = {
      enable = lib.mkForce false;
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
    installer.channel.enable = false; # 不把 nixpkgs 源码打进镜像，缩小体积；安装走 flake 流程用不到
    activationScripts.root-password = ''
      mkdir -p /var/shared
      tr -dc 'A-HJ-KMNP-Y3-9' < /dev/urandom | fold -w 4 | head -n 4 | paste -sd "-" - > /var/shared/root-password
      echo "root:$(cat /var/shared/root-password)" | chpasswd
    '';
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 70;
  };

  boot = {
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
    initrd.systemd.emergencyAccess = true;
    supportedFilesystems = {
      ext4 = true;
      exfat = true;
      ext2 = true;
      bcachefs = true;
    };
    kernelParams = [
      "nouveau.modeset=0"
      "console=ttyS0,115200" # 串口调试
      "console=tty0"
      "zswap.zpool=zsmalloc"
      "boot.shell_on_fail"
    ];
  };
  environment = {
    systemPackages = [
      pkgs.disko
      pkgs.rsync
      pkgs.jq
      pkgs.nixos-facter
      pkgs.bore-cli
      pkgs.geph
      pkgs.clash-rs
      pkgs.proxychains-ng
      pkgs.dae
      pkgs.bind.dnsutils
      pkgs.ripgrep
      pkgs.btop
      pkgs.progress
      pkgs.tmux
      pkgs.file
      pkgs.nh
      pkgs.sbctl
      pkgs.maple-mono.Normal-CN
      network-status
    ];
    enableAllTerminfo = true;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    targets.kmscon.enable = false;
  };

  # https://github.com/NixOS/nixpkgs/issues/219239
  programs = {
    bash.interactiveShellInit = lib.mkAfter ''
      if [[ "$(tty)" =~ /dev/(tty1|hvc0|ttyS0)$ ]]; then
        watch --no-title --color ${network-status}/bin/network-status
      fi
    '';
    fish = {
      enable = true;
      useBabelfish = true;
    };
  };

  console = {
    earlySetup = true;
    packages = [ pkgs.kmscon ];
  };

  users.users.root = {
    shell = pkgs.bash; # 非 POSIX 兼容 Shell 会导致 nixos-anywhere 出问题
  };

  security.sudo.enable = false;

  systemd = {
    tmpfiles.rules = [ "d /var/shared 0700 root root - -" ];
    services = {
      log-network-status = {
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          StandardOutput = "journal+console";
          ExecStart = [
            "-${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online"
            "${pkgs.iproute2}/bin/ip -c addr"
            "${pkgs.iproute2}/bin/ip -c -6 route"
            "${pkgs.iproute2}/bin/ip -c -4 route"
            "${pkgs.systemd}/bin/networkctl status"
          ];
        };
      };
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
          "bore-tunnel.service"
          "network-online.target"
        ];
        wants = [
          "bore-tunnel.service"
          "network-online.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = pkgs.writeShellScript "announce-login-info" ''
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

            last_address=""
            while true; do
              until grep -q 'listening at bore.pub' /var/shared/bore.log 2>/dev/null; do
                sleep 1
              done

              bore_address=$(grep -oP 'listening at bore.pub:\K\d+' /var/shared/bore.log | tail -1 || true)
              if [[ -n "$bore_address" && "$bore_address" != "$last_address" ]]; then
                echo "Bore 地址已就绪: bore.pub:$bore_address"
                local_addrs=$(ip -json addr | jq '[map(.addr_info) | flatten | .[] | select(.scope == "global") | .local]')
                jq -nc \
                  --arg password "$(cat /var/shared/root-password)" \
                  --argjson local_addrs "$local_addrs" \
                  --arg bore_address "bore.pub:$bore_address" \
                  '{ pass: $password, addrs: $local_addrs, bore: $bore_address }' \
                  > /var/shared/login.json

                qrencode -s 2 -m 2 -t utf8 -o /var/shared/qrcode.utf8 < /var/shared/login.json
                last_address="$bore_address"
              fi
              sleep 5
            done
          '';
          PrivateTmp = "true";
          Restart = "always";
          RestartSec = 5;
        };
      };
    };
  };
}

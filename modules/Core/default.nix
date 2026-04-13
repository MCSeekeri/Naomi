{
  inputs,
  outputs,
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nur.modules.nixos.default
    inputs.nix-index-database.nixosModules.nix-index
    ./apparmor.nix
    ./avahi.nix
    ./boot.nix
    ./fonts.nix
    #./hardened.nix
    ./i18n.nix
    ./nix.nix
    ./programs.nix
    ./sops.nix
    ./stylix.nix
    ./ssh.nix
    ./tailscale.nix
    ./users.nix
    ./zram.nix
  ];

  system = {
    autoUpgrade = {
      enable = lib.mkDefault true;
      flake = lib.mkDefault "github:MCSeekeri/Naomi";
      operation = lib.mkDefault "boot";
      allowReboot = lib.mkDefault true;
      rebootWindow = {
        # 凌晨更新，提神醒脑
        lower = "01:00";
        upper = "04:00";
      };
    };
    nixos = {
      # 设置此项以自研操作系统
      # 至少，系统信息里面看着是自研的
      # codeName = "";
      # release = "";
    };
    etc.overlay.enable = true;
    nixos-init.enable = true;
  };

  nixpkgs = {
    overlays = [
      self.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
    hostPlatform = lib.mkDefault "x86_64-linux"; # 在我买得起果子设备之前，这个假设估计一直有效……
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit self inputs outputs; };
    sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
      "${self}/modules/Home/xdg.nix"
    ];
  };

  networking = {
    networkmanager.enable = lib.mkDefault false;
    useNetworkd = true; # 实验性启用
    dhcpcd.enable = false;
    nftables.enable = true;
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = lib.mkDefault "fq";
    "net.ipv4.tcp_congestion_control" = lib.mkDefault "bbr";
    "net.ipv4.tcp_fastopen" = lib.mkDefault 3;
    "net.ipv4.tcp_mtu_probing" = lib.mkDefault 1;
  };

  services = {
    userborn.enable = true;
    resolved.enable = true;
  };

  environment = {
    shellAliases = {
      sudo = "run0 --background=";
    };
    # 基于 systemd-run 的 sudo 替代品，除了每次都要输密码之外没什么缺点
    # [TODO] 等 26.05 发布之后看看新版本是否修复

    stub-ld.enable = lib.mkForce false;

    # userborn 不支持分配 uid/gid 范围
    # 抄袭自 https://github.com/StarryReverie/StarryNix-Infrastructure/blob/master/modules/system/core/user-management/default.nix
    etc =
      let
        subuids = pkgs.runCommand "subuid-allocation" { } ''
          root_start=1000000
          root_count=1000000000
          normal_start=$((root_start + root_count))
          normal_count=65536
          max_normal_uid=9999

          echo "0:$root_start:$root_count" > $out

          uid=1000
          while [ "$uid" -le $max_normal_uid ]; do
            echo "$uid:$normal_start:$normal_count" >> $out
            uid=$((uid + 1))
            normal_start=$((normal_start + normal_count))
          done
        '';
      in
      {
        "subuid" = {
          source = subuids;
          mode = "0444";
        };
        "subgid" = {
          source = subuids;
          mode = "0444";
        };
      };
  };

  security = {
    polkit.enable = true;
    sudo.enable = false;
    tpm2.enable = lib.mkDefault true;
  };

  systemd = {
    coredump.extraConfig = "Storage=none"; # 不需要转储
    # enableStrictShellChecks = true;
    # [TODO] 等我整明白如何给上游提交 PR 修复这些问题再说
    network.wait-online.enable = false;
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableUserSlices = true;
      enableSystemSlice = true;
    };
  };

  virtualisation.vmVariant = {
    imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
    virtualisation = {
      cores = lib.mkDefault 4;
      memorySize = lib.mkDefault 4096;
      diskSize = lib.mkDefault 16384;
      graphics = lib.mkDefault true;
    };

    system.nixos-init.enable = lib.mkForce false;
    hardware = {
      cpu.type = lib.mkForce "qemu";
      gpu.type = lib.mkForce "";
    };
    services = {
      btrfs.autoScrub.enable = lib.mkForce false;
      beesd.filesystems = lib.mkForce { };
      snapper.configs = lib.mkForce { };
    };
  };
}

{
  inputs,
  outputs,
  self,
  pkgs,
  lib,
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
    sharedModules = [ inputs.nix-index-database.homeModules.nix-index ];
  };

  networking = {
    networkmanager.enable = lib.mkDefault false;
    useNetworkd = true; # 实验性启用
    dhcpcd.enable = false;
    nftables.enable = true;
  };

  services = {
    userborn.enable = true;
  };

  # userborn 不支持分配 uid/gid 范围
  # 抄袭自 https://github.com/StarryReverie/StarryNix-Infrastructure/blob/master/modules/system/core/user-management/default.nix
  environment.etc =
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

  security = {
    sudo-rs = {
      # 不是很支持 sudo -E
      enable = true;
      execWheelOnly = lib.mkDefault true; # https://unix.stackexchange.com/questions/1262/where-did-the-wheel-group-get-its-name
    };
    tpm2.enable = lib.mkDefault true;
  };

  systemd = {
    coredump.extraConfig = "Storage=none"; # 不需要转储
    # enableStrictShellChecks = true;
    # [TODO] 等我整明白如何给上游提交 PR 修复这些问题再说
    network.wait-online.enable = false;
  };

}

{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
    # 需要用 modulesPath 避免纯评估模式出错，大概
  ];
  nixpkgs.hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  # 网络配置
  networking = {
    hostName = "cuba"; # 主机名，设置好之后最好不要修改
  };

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}

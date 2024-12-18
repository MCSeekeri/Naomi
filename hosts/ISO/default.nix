{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/Core

    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/sunshine.nix
    ../../modules/Desktop/programs.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64

  # 网络配置
  networking = {
    hostName = "Naomi-LiveCD"; # 主机名，设置好之后最好不要修改
    networkmanager.enable = true;
  };

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}
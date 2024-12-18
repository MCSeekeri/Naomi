{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  nixpkgs.hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

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
{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Server/hardened.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/sunshine.nix
    ../../modules/Desktop/programs.nix
    ../../modules/Desktop/gaming.nix
    ../../modules/Desktop/fcitx5.nix

    ../../users/mcseekeri
  ];

  # 网络配置
  networking = {
    hostName = "manhattan"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}

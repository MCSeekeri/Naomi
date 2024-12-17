{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/sunshine.nix
  ];

  # 网络配置
  networking = {
    hostName = "Naomi"; # 主机名，设置好之后最好不要修改
    networkmanager.enable = true;
  };
  
  home-manager.users.mcseekeri = import ../../users/mcseekeri.nix;

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}
{ ... }:
{
  imports = [
    ./disko-config.nix

    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/hardened.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/programs.nix
    ../../modules/Desktop/fcitx5.nix
    ../../modules/Games/minecraft_server.nix

    ../../modules/Containers/aquadx.nix

    ../../users/mcseekeri
  ];

  # 网络配置
  networking = {
    hostName = "costarica"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
  virtualisation.vmware.guest.enable = true;
}

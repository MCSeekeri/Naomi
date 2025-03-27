{ self, ... }:
{
  imports = [
    ./disko-config.nix

    "${self}/modules/Core"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/hardened.nix"
    "${self}/modules/Desktop/gui.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/fcitx5.nix"

    "${self}/modules/Services/nginx.nix"

    "${self}/modules/Games/aquadx.nix"

    "${self}/users/mihomo"
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

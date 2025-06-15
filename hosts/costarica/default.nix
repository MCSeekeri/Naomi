{ self, ... }:
{
  imports = [
    ./disko-config.nix

    "${self}/modules/Core"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/fcitx5.nix"

    "${self}/modules/Services/nginx.nix"

    "${self}/modules/Games/AquaDX"

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

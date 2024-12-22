{
  ...
}:
{
  imports = [
    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Server/hardened.nix
    ../../modules/Server/virt.nix
    ../../modules/Server/nvidia.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/programs.nix

    ../../users/mcseekeri
  ];

  # 网络配置
  networking = {
    hostName = "seychelles"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}
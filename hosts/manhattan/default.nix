{ lib, ... }:
{
  imports = [
    ./disko-config.nix

    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Server/hardened.nix
    ../../modules/Server/failsafe.nix
    ../../modules/Server/lxd.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/sunshine.nix
    ../../modules/Desktop/programs.nix
    ../../modules/Desktop/gaming.nix
    ../../modules/Desktop/fcitx5.nix
    ../../modules/Desktop/clash.nix
    ../../modules/Desktop/stylix.nix

    ../../modules/Services/cockpit.nix
    ../../modules/Services/cloudflared.nix
    ../../modules/Services/uptime-kuma.nix

    ../../modules/Games/minecraft.nix
    ../../modules/Games/minecraft_server.nix

    ../../users/mcseekeri
    ../../users/remote
  ];

  # 网络配置
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "manhattan"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "ahci"
    "sr_mod"
  ];

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}

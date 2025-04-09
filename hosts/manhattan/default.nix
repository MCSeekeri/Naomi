{ lib, self, ... }:
{
  imports = [
    ./disko-config.nix

    "${self}/modules/Core"

    "${self}/modules/Hardware/intel.nix"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    # "${self}/modules/Server/hardened.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Desktop/gui.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    "${self}/modules/Desktop/clash.nix"
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/cups.nix"
    "${self}/modules/Desktop/bluetooth.nix"

    "${self}/modules/Services/cockpit.nix"
    "${self}/modules/Services/uptime-kuma.nix"
    "${self}/modules/Services/cloudflared.nix"
    "${self}/modules/Services/ollama.nix"
    "${self}/modules/Services/searx.nix"
    "${self}/modules/Services/archisteamfarm.nix"
    # "${self}/modules/Services/privatebin.nix"
    "${self}/modules/Services/misskey.nix"
    "${self}/modules/Services/glances.nix"

    "${self}/modules/Games/aquadx.nix"
    "${self}/modules/Games/retro.nix"

    "${self}/modules/Containers/peerbanhelper.nix"

    "${self}/users/mcseekeri"
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

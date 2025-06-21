{ lib, self, ... }:
{
  imports = [
    "${self}/modules/Core"

    "${self}/modules/Hardware/intel.nix"
    "${self}/modules/Hardware/qemu.nix"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Server/virt/libvirt.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/cups.nix"
    "${self}/modules/Desktop/bluetooth.nix"
    "${self}/modules/Desktop/hyprland.nix"

    "${self}/modules/Services/searx.nix"
    "${self}/modules/Services/archisteamfarm.nix"

    "${self}/modules/Games/retro.nix"

    "${self}/modules/Containers/peerbanhelper.nix"

    "${self}/users/mcseekeri"
  ];

  # 网络配置
  networking = {
    hostName = "cyprus"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
  };
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  system = {
    stateVersion = "25.05";
    autoUpgrade.enable = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-partlabel/root";

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/boot";
    fsType = "ext4";
  };

  fileSystems."/boot/EFI" = {
    device = "/dev/disk/by-partlabel/EFI";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
}

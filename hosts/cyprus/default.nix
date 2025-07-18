{
  pkgs,
  lib,
  self,
  ...
}:
{
  imports = [
    "${self}/modules/Core"

    "${self}/modules/Hardware/intel.nix"
    "${self}/modules/Hardware/nvidia_laptop.nix"
    "${self}/modules/Hardware/cuda.nix"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Server/virt/libvirt.nix"
    "${self}/modules/Server/virt/incus.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/waydroid.nix"
    "${self}/modules/Desktop/cups.nix"

    "${self}/modules/Services/searx.nix"
    "${self}/modules/Services/archisteamfarm.nix"
    "${self}/modules/Services/adguardhome.nix"

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
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
      ];
      luks.devices."root".device = "/dev/disk/by-partlabel/root";
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  system = {
    stateVersion = "25.05";
    autoUpgrade.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/home" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@home"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@nix"
      ];
    };
  };

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    beesd.filesystems = {
      root = {
        spec = "LABEL=btrfs-root";
        hashTableSizeMB = 4096;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "40.0"
        ];
      };
      Games = {
        spec = "PARTLABEL=Games";
        hashTableSizeMB = 4096;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "40.0"
        ];
      };
    };
    snapper.configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };

}

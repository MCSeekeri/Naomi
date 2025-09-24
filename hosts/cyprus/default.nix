{ lib, self, ... }:
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
    "${self}/modules/Server/virt/virtualbox.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/obs.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/waydroid.nix"
    "${self}/modules/Desktop/cups.nix"
    "${self}/modules/Desktop/embedded.nix"

    "${self}/modules/Services/archisteamfarm.nix"
    "${self}/modules/Services/dae"
    # "${self}/modules/Services/geph5.nix"
    "${self}/modules/Services/localsend.nix"

    "${self}/modules/Games/retro.nix"
    "${self}/modules/Games/minecraft.nix"

    "${self}/modules/Containers/peerbanhelper.nix"

    "${self}/users/mcseekeri"
  ];

  # 网络配置
  networking = {
    hostName = "cyprus"; # 主机名，设置好之后最好不要修改
  };

  nix.buildMachines = [
    {
      hostName = "ThinkStation2";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 16;
      speedFactor = 16;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];

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
        "usb_storage"
        "sd_mod"
      ];
      luks.devices."root".device = "/dev/disk/by-partlabel/root";
    };
    kernelModules = [ "kvm-intel" ];
    # kernelPackages = pkgs.linuxPackages_zen; # 编译失败
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
          "15.0"
        ];
      };
      Games = {
        spec = "LABEL=Games";
        hashTableSizeMB = 4096;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "15.0"
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

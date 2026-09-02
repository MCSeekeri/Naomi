{
  self,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    "${self}/modules/Core"
    "${self}/modules/Core/prc.nix"

    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/ntfy-agent.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Server/virt/libvirt.nix"
    # "${self}/modules/Server/virt/virtualbox.nix"
    "${self}/modules/Server/virt/k8s.nix"
    "${self}/modules/Server/podman.nix"

    "${self}/modules/Desktop/niri.nix"
    "${self}/modules/Desktop/ananicy.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/obs.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/waydroid.nix"
    "${self}/modules/Desktop/cups.nix"
    "${self}/modules/Desktop/embedded.nix"
    "${self}/modules/Desktop/yubikey.nix"
    "${self}/modules/Desktop/wine.nix"
    "${self}/modules/Desktop/extra-fonts.nix"
    "${self}/modules/Desktop/appimage.nix"

    "${self}/modules/Services/archisteamfarm.nix"
    "${self}/modules/Services/dae"
    "${self}/modules/Services/geph5.nix"
    "${self}/modules/Services/localsend.nix"

    "${self}/modules/Games/retro.nix"
    "${self}/modules/Games/minecraft.nix"

    "${self}/modules/Services/peerbanhelper.nix"

    "${self}/users/mcseekeri"
  ];

  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager # 「No 模块，No 覆盖」，Nix 的这句名言想必大家都熟记于心吧……
    {
      home.file."steam/steam/steam_dev.cfg".text = ''
        @nClientDownloadEnableHTTP2PlatformLinux 0
        unShaderBackgroundProcessingThreads 16
      '';
    }
  ];

  home-manager.users.mcseekeri.xdg.configFile."niri/host.kdl".text = ''
    output "eDP-1" {
        scale 1.25
        variable-refresh-rate
    }
  '';

  # 网络配置
  networking = {
    hostName = "cyprus"; # 主机名，设置好之后最好不要修改
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
  hardware = {
    cpu = {
      type = "intel";
      # arch = "raptorlake";
    };
    gpu.type = "nvidia";
    deviceType = "laptop";
    nvidia.powerManagement = {
      enable = true;
      finegrained = true;
    };
  };
  boot = {
    loader.limine.secureBoot.enable = true;
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks = {
        devices."root" = {
          device = "/dev/disk/by-partlabel/root";
          allowDiscards = true;
          crypttabExtraOpts = [
            "fido2-device=auto"
            "tpm2-device=auto"
            "token-timeout=10s"
            "password-cache=no"
            "tries=3"
          ];
          # https://www.freedesktop.org/software/systemd/man/251/systemd-cryptenroll.html
          # systemd-cryptenroll --fido2-device=auto
        };
        devices."Games" = {
          device = "/dev/disk/by-partlabel/Games";
          allowDiscards = true;
        };
      };
    };
    kernelModules = [
      "kvm-intel"
      "ntsync"
    ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [
      "transparent_hugepage=always"
      "rcutree.enable_rcu_lazy=1"
    ];
    kernel.sysfs = {
      "kernel"."mm" = {
        "transparent_hugepage" = {
          "defrag" = "defer+madvise";
        };
        "khugepaged" = {
          "max_ptes_none" = 409;
        };
      };
    };
    kernel.sysctl."kernel.yama.ptrace_scope" = 0;
  };

  system = {
    stateVersion = "26.05";
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
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
        "noatime"
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

    "/run/media/mcseekeri/Games" = {
      device = "/dev/mapper/Games";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
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
        hashTableSizeMB = 6144;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "12.0"
        ];
      };
      Games = {
        spec = "LABEL=Games";
        hashTableSizeMB = 1024;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "12.0"
        ];
      };
    };
    snapper.configs = {
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
    displayManager.ly.enable = true;

    fwupd.enable = true;

    wivrn = {
      enable = true;
      highPriority = true;
      config.enable = true;
      steam.importOXRRuntimes = true;
      autoStart = true;
      openFirewall = true;
    };
    smartd.enable = true;
  };

  environment = {
    systemPackages = [
      pkgs.wayvr
      pkgs.monado-vulkan-layers
    ];
  };

  security = {
    pam = {
      yubico = {
        enable = true;
        id = [ "23392590" ];
      };
    };
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
      usbmon.enable = true;
      dumpcap.enable = true;
    };
  };
}

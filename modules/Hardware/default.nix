{
  config,
  lib,
  pkgs,
  ...
}:
# 疯狂大重构……这套系统已经复杂到我看不懂了

let
  hasIgpu = lib.hasIgpu config;
  hasDgpu = lib.hasDgpu config;
  hasGpu = lib.hasGpu config;
  hasIntelGpu = lib.hasIntelGpu config;
  hasAmdGpu = lib.hasAmdGpu config;
  hasNvidiaGpu = lib.hasNvidiaGpu config;
  isServer = lib.isServer config;
  isLaptop = lib.isLaptop config;
  displayGpu = lib.displayGpu config;
  mediaDriver = lib.vaapiDriver config;
  cpuType = config.hardware.cpu.type;
in
{
  options = {
    hardware = {
      cpu.type = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "intel"
            "amd"
            "qemu"
          ]
        );
        default = null;
        description = "CPU 类型，影响特定于厂商的优化和驱动。";
      };

      gpu = {
        igpu = lib.mkOption {
          type = lib.types.enum [
            "none"
            "intel"
            "amd"
          ];
          default = "none";
          description = "核显厂商";
        };

        dgpu = lib.mkOption {
          type = lib.types.enum [
            "none"
            "nvidia"
            "amd"
          ];
          default = "none";
          description = "独显厂商";
        };

        display = lib.mkOption {
          type = lib.types.enum [
            "auto"
            "igpu"
            "dgpu"
          ];
          default = "auto";
          description = ''
            负责显示的 GPU。auto 表示有核显时用核显，否则用独显；
            MUX 切到独显直连时应显式设为 dgpu。
          '';
        };
      };

      deviceType = lib.mkOption {
        type = lib.types.enum [
          "desktop"
          "laptop"
          "server"
        ];
        description = "设备类型，影响电源管理，服务优先级等配置，必须手动设置。";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = displayGpu != "igpu" || hasIgpu;
        message = "错误：hardware.gpu.display = \"igpu\"，但没有配置核显";
      }
      {
        assertion = displayGpu != "dgpu" || hasDgpu;
        message = "错误：hardware.gpu.display = \"dgpu\"，但没有配置独显";
      }
    ];

    nix = lib.mkMerge [
      {
        daemonCPUSchedPolicy = lib.mkDefault "idle";
        daemonIOSchedClass = lib.mkDefault "idle";
        daemonIOSchedPriority = lib.mkDefault 7;
      }
      (lib.mkIf isServer {
        daemonCPUSchedPolicy = "other";
        daemonIOSchedClass = "best-effort";
        daemonIOSchedPriority = 4;
      })
    ];

    hardware = lib.mkMerge [
      {
        enableAllFirmware = lib.mkDefault true;
        cpu = {
          intel.updateMicrocode = lib.mkIf (cpuType == "intel") true;
          amd.updateMicrocode = lib.mkIf (cpuType == "amd") true;
        };
      }
      (lib.mkIf hasNvidiaGpu {
        nvidia = {
          open = lib.mkDefault ((config.hardware.nvidia.package.open or null) != null);
          modesetting.enable = lib.mkDefault true;
          nvidiaPersistenced = lib.mkDefault (!isLaptop);
          dynamicBoost.enable = lib.mkDefault isLaptop;
          videoAcceleration = lib.mkIf (mediaDriver != "nvidia") false;
          prime =
            lib.mkIf
              (
                hasIgpu
                && displayGpu == "igpu"
                && !config.hardware.nvidia.datacenter.enable
                && !config.hardware.nvidia.prime.sync.enable
                && !config.hardware.nvidia.prime.reverseSync.enable
              )
              {
                offload = {
                  enable = lib.mkOverride 990 true;
                  enableOffloadCmd = lib.mkOverride 990 true;
                };
              };
        };
        nvidia-container-toolkit.enable = lib.mkDefault true;
      })
      {
        intel-gpu-tools.enable = hasIntelGpu && !isServer;
        graphics = {
          enable = lib.mkDefault hasGpu;
          extraPackages =
            with pkgs;
            lib.optionals hasGpu [ ocl-icd ]
            ++ lib.optionals hasIntelGpu [
              intel-media-driver
              intel-compute-runtime
              vpl-gpu-rt
            ];
          extraPackages32 = lib.mkIf config.hardware.graphics.enable32Bit (
            with pkgs.pkgsi686Linux;
            lib.optionals hasIntelGpu [
              intel-media-driver
              intel-vaapi-driver
            ]
          );
        };
        amdgpu = lib.mkIf hasAmdGpu {
          opencl.enable = true;
          initrd.enable = lib.mkDefault (!isServer);
        };
      }
    ];

    boot = {
      kernelParams = lib.flatten (
        lib.optionals (cpuType == "intel") [ "intel_iommu=on" ]
        ++ lib.optionals (cpuType == "amd") [
          "amd_iommu=on"
          "amd_pstate=active"
        ]
        ++ lib.optionals (!isServer) [
          "nowatchdog"
          "nmi_watchdog=0"
        ]
      );
    };

    networking.networkmanager.wifi.powersave = lib.mkDefault isLaptop;

    services = lib.mkMerge [
      (lib.mkIf (hasNvidiaGpu && !config.hardware.nvidia.datacenter.enable) {
        xserver.videoDrivers = lib.mkDefault (
          if displayGpu == "igpu" then
            [
              "modesetting"
              "nvidia"
            ]
          else
            [ "nvidia" ]
        );
      })
      (lib.mkIf (!isServer) {
        udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="block", KERNEL=="nvme*n*", ATTR{queue/read_ahead_kb}="1024"
        '';
      })
      (lib.mkIf isLaptop {
        power-profiles-daemon.enable = lib.mkDefault true;
        thermald.enable = lib.mkDefault (cpuType == "intel");
      })
    ];

    systemd.services.nix-gc.serviceConfig =
      if isServer then
        {
          CPUSchedulingPolicy = "other";
          IOSchedulingClass = "best-effort";
          IOSchedulingPriority = 4;
        }
      else
        {
          CPUSchedulingPolicy = "batch";
          IOSchedulingClass = "idle";
          IOSchedulingPriority = 7;
        };

    environment = {
      systemPackages =
        with pkgs;
        [
          clinfo
          lm_sensors
        ]
        ++ lib.optionals hasGpu [
          vulkan-tools
          libva-utils
          nvtopPackages.full
        ]
        ++ lib.optionals hasNvidiaGpu [ cudaPackages.cuda_cudart ]
        ++ lib.optionals hasAmdGpu [
          rocmPackages.rocm-smi
          amdgpu_top
        ]
        ++ lib.optionals (!isServer) [ mpv ]
        ++ lib.optionals isLaptop [
          s-tui
          powerstat
          stress
        ];

      sessionVariables = lib.mkMerge [
        (lib.mkIf (mediaDriver != null) { LIBVA_DRIVER_NAME = lib.mkDefault mediaDriver; })
        (lib.mkIf (mediaDriver == "nvidia") { NVD_BACKEND = lib.mkDefault "direct"; })
        (lib.mkIf hasAmdGpu {
          RUSTICL_ENABLE = "radeonsi";
          HIP_VISIBLE_DEVICES = "0";
        })
      ];
    };
  };
}

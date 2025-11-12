{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
# nixos-hardware 比这个配置完善多了，要不是动态 import 在技术上不可行我就直接弃用这个了
# 也许未来可以通过 builtin 读取文件是否存在的方式来实现动态导入，但会有点怪……
let
  isNvidia = config.hardware.gpu.type == "nvidia";
  isIntel = config.hardware.gpu.type == "intel" || config.hardware.cpu.type == "intel";
  isAMD = config.hardware.gpu.type == "amd" || config.hardware.cpu.type == "amd";
  isQemu = config.hardware.cpu.type == "qemu";
in
{
  options = {
    hardware = {
      cpu.arch = lib.mkOption {
        type = lib.types.enum [
          "x86_64-v2"
          "x86_64-v3"
          "x86_64-v4"
          ""
        ];
        default = "";
        description = "CPU 指令集兼容性，影响包和编译设置。";
      };

      cpu.optimized = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "是否启用针对处理器指令集优化的编译。";
      };

      cpu.type = lib.mkOption {
        type = lib.types.enum [
          "intel"
          "amd"
          "qemu"
          ""
        ];
        default = "";
        description = "CPU 类型，影响特定于厂商的优化和驱动。";
      };

      cpu.tune = lib.mkOption {
        type = lib.types.str;
        default = "generic";
        description = "处理器架构的代号，请参考 https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html";
      };

      gpu.type = lib.mkOption {
        type = lib.types.enum [
          "nvidia"
          "intel"
          "amd"
          ""
        ];
        default =
          if config.hardware.cpu.type == "intel" then
            "intel"
          else if config.hardware.cpu.type == "amd" then
            "amd"
          else
            "";
        description = "GPU 类型，决定使用的图形驱动和相关配置。";
      };

      deviceType = lib.mkOption {
        type = lib.types.enum [
          "desktop"
          "laptop"
          "server"
        ];
        default = "desktop";
        description = "设备类型，影响电源管理和相关配置。";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !(config.hardware.gpu.type != "" && config.hardware.cpu.type == "");
        message = "错误：已设置 hardware.gpu.type (${config.hardware.gpu.type}) 但未设置 hardware.cpu.type";
      }
      {
        assertion = !(config.hardware.cpu.optimized && config.hardware.cpu.type == "");
        message = "错误：启用了 CPU 指令集优化但未设置 hardware.cpu.type";
      }
    ];

    nix = lib.mkMerge [
      {
        settings = {
          system-features =
            let
              levels = {
                "x86_64-v2" = [ "gccarch-x86-64-v2" ];
                "x86_64-v3" = [
                  "gccarch-x86-64-v3"
                  "gccarch-x86-64-v2"
                ];
                "x86_64-v4" = [
                  "gccarch-x86-64-v4"
                  "gccarch-x86-64-v3"
                  "gccarch-x86-64-v2"
                ];
              };
            in
            lib.optionals (config.hardware.cpu.arch != "") levels.${config.hardware.cpu.arch};
        };
      }
      (lib.mkIf (config.hardware.deviceType == "server") {
        daemonCPUSchedPolicy = "other";
        daemonIOSchedClass = "best-effort";
        daemonIOSchedPriority = 4;
      })
      (lib.mkIf (config.hardware.deviceType != "server") {
        daemonCPUSchedPolicy = lib.mkDefault "idle";
        daemonIOSchedClass = lib.mkDefault "idle";
        daemonIOSchedPriority = lib.mkDefault 7;
      })
    ];

    # 从 Chaotic's Nyx 偷来的
    nixpkgs = {
      overlays = [ inputs.nixgl.overlay ];
      config = {
        cudaSupport = lib.mkIf isNvidia true;
        rocmSupport = lib.mkIf isAMD true;
      };
      hostPlatform = lib.mkIf config.hardware.cpu.optimized {
        gcc.arch = lib.replaceStrings [ "_" ] [ "-" ] config.hardware.cpu.arch;
        gcc.tune = config.hardware.cpu.tune;
        system = "x86_64-linux";
      };
    };

    hardware = {
      intel-gpu-tools.enable = lib.mkIf isIntel true;
      cpu = {
        intel.updateMicrocode = lib.mkIf (config.hardware.cpu.type == "intel") true;
        amd.updateMicrocode = lib.mkIf (config.hardware.cpu.type == "amd") true;
      };
      firmware = [ pkgs.linux-firmware ];

      graphics = {
        extraPackages =
          with pkgs;
          lib.flatten (
            [ mesa ]
            ++ lib.optionals isIntel [
              intel-media-driver
              intel-compute-runtime
              vpl-gpu-rt
            ]
            ++ lib.optionals isAMD [
              rocmPackages.rocm-runtime
              rocmPackages.rocm-opencl-runtime
            ]
            ++ lib.optionals isNvidia [ nvidia-vaapi-driver ]
            ++ lib.optionals isQemu [
              virglrenderer
              virtualgl
            ]
          );

        extraPackages32 =
          with pkgs.pkgsi686Linux;
          lib.flatten (
            [ mesa ]
            ++ lib.optionals isIntel [
              intel-media-driver
              intel-vaapi-driver
            ]
            ++ lib.optionals (!isQemu) [
              libvdpau-va-gl
              vdpauinfo
            ]
          );
      };

      nvidia = lib.mkIf isNvidia {
        open = true;
        nvidiaSettings = true;
        modesetting.enable = true;
        nvidiaPersistenced = true;
        datacenter.enable = lib.mkDefault false;
        powerManagement = {
          enable = lib.mkDefault false;
          finegrained = lib.mkDefault false;
        };
        prime = lib.mkIf (isNvidia && config.hardware.deviceType == "laptop") {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = lib.mkIf (config.hardware.cpu.type == "intel") "PCI:0:2:0";
          amdgpuBusId = lib.mkIf (config.hardware.cpu.type == "amd") "PCI:54:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
      nvidia-container-toolkit.enable = lib.mkIf isNvidia true;

      amdgpu = lib.mkIf isAMD {
        initrd.enable = true;
        opencl.enable = true;
      };
    };
    boot = {
      kernelParams = lib.flatten (
        lib.optionals (config.hardware.cpu.type == "intel") [ "intel_iommu=on" ]
        ++ lib.optionals (config.hardware.cpu.type == "amd") [
          "amd_iommu=on"
          "amd_pstate=active"
        ]
      );
    };

    services = lib.mkMerge [
      (lib.mkIf isQemu {
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
        spice-autorandr.enable = true;
        spice-webdavd.enable = true;
      })
      (lib.mkIf isNvidia { xserver.videoDrivers = [ "nvidia" ]; })
      (lib.mkIf isIntel { xserver.videoDrivers = [ "intel" ]; })
      (lib.mkIf (config.hardware.deviceType == "laptop") {
        tlp.enable = lib.mkDefault (!config.services.power-profiles-daemon.enable);
      })
    ];

    systemd.services.nix-gc.serviceConfig =
      if config.hardware.deviceType == "server" then
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
        lib.flatten (
          [
            mpv
            (lib.optionals (!isQemu) [
              vulkan-tools
              libva-utils
              nvtopPackages.full
              mesa-demos
            ])
          ]
          ++ lib.optionals isIntel [
            nixgl.nixGLIntel
            nixgl.nixVulkanIntel
            intel-gpu-tools
          ]
          ++ lib.optionals isAMD [
            rocmPackages.rocm-smi
            rocmPackages.amdgpu_top
            clinfo
          ]
          ++ lib.optionals isNvidia [
            nvidia-vaapi-driver
            nv-codec-headers-12
            cudaPackages.cudatoolkit
            cudaPackages.cuda_cudart
            cudaPackages.cuda_nvcc
            cudaPackages.cuda_cccl
            linuxPackages.nvidia_x11
            libGLU
            libGL
            freeglut
          ]
          ++ lib.optionals isQemu [
            virglrenderer
            virtualgl
          ]
        );

      sessionVariables = lib.mkMerge [
        (lib.mkIf isIntel {
          LIBVA_DRIVER_NAME = "iHD";
          VDPAU_DRIVER = "va_gl";
        })
        (lib.mkIf isAMD {
          LIBVA_DRIVER_NAME = "radeonsi";
          VDPAU_DRIVER = "radeonsi";
          RUSTICL_ENABLE = "radeonsi";
          ROC_ENABLE_PRE_VEGA = "1";
        })
        (lib.mkIf isNvidia { CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}"; })
      ];
    };

    specialisation = lib.mkIf (isNvidia && config.hardware.deviceType == "laptop") {
      battery-saver.configuration = {
        system.nixos.tags = [ "battery-saver" ];
        hardware.gpu.type = lib.mkForce "";
        services.xserver.videoDrivers = lib.mkForce (
          if config.hardware.gpu.type == "intel" then
            [ "intel" ]
          else if config.hardware.gpu.type == "amd" then
            [ "amdgpu" ]
          else
            [ ]
        );
      };
    };
  };
}

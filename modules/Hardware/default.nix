{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  isNvidia = config.hardware.gpu.type == "nvidia" || config.hardware.gpu.type == "nvidia_laptop";
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
          "nvidia_laptop"
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
    };
  };

  config = {
    assertions = [
      {
        assertion = !(config.hardware.gpu.type != "" && config.hardware.cpu.type == "");
        message = "错误：已设置 hardware.gpu.type (${config.hardware.gpu.type}) 但未设置 hardware.cpu.type,必须同时设置两者或仅设置 cpu.type";
      }
      {
        assertion = !(config.hardware.cpu.optimized && config.hardware.cpu.type == "");
        message = "错误：启用了 CPU 指令集优化但未设置 hardware.cpu.type,必须同时设置两者";
      }
    ];

    nix.settings.system-features =
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
              rocmPackages.clr
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
        prime = lib.mkIf (config.hardware.gpu.type == "nvidia_laptop") {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          sync.enable = lib.mkDefault false;
          intelBusId = lib.mkDefault "PCI:0:2:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };
      nvidia-container-toolkit.enable = lib.mkIf isNvidia true;
    };

    boot.kernelParams = lib.flatten (
      lib.optionals (config.hardware.cpu.type == "intel") [ "intel_iommu=on" ]
      ++ lib.optionals (config.hardware.cpu.type == "amd") [ "amd_iommu=on" ]
    );

    services = lib.mkMerge [
      (lib.mkIf isQemu {
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
        spice-autorandr.enable = true;
        spice-webdavd.enable = true;
      })
      (lib.mkIf isNvidia { xserver.videoDrivers = [ "nvidia" ]; })
      (lib.mkIf isIntel { xserver.videoDrivers = [ "intel" ]; })
    ];

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
          ROC_ENABLE_PRE_VEGA = "1";
        })
        (lib.mkIf isNvidia { CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}"; })
      ];
    };
  };
}

{ pkgs, self, ... }:
# Why Are We Still Here? Just To Suffer?
# 仅作为思路记录，未经任何测试。
{
  imports = [ "${self}/modules/Hardware/nvidia.nix" ];
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cccl
    linuxPackages.nvidia_x11
    libGLU
    libGL
    freeglut
    xorg.libXi
    xorg.libXmu
    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr
  ];
  environment.sessionVariables = rec {
    CUDA_PATH = pkgs.cudaPackages.cudatoolkit;
  };

  nixpkgs.config.cudaSupport = true;
}

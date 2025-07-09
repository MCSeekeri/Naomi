{
  pkgs,
  lib,
  self,
  ...
}:
{
  imports = [ "${self}/modules/Hardware/acceleration.nix" ];
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = true;
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # 只考虑图灵之后的设备。
      # 这边基本都是艾达起步，不必考虑旧设备兼容。
      nvidiaSettings = true;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      datacenter.enable = lib.mkDefault false; # NVLink
      powerManagement = {
        enable = lib.mkDefault false; # 服务器不需要考虑休眠，有资料指出这东西有点毛病
        finegrained = lib.mkDefault false;
      };
      # package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.production; # 25.05 版本默认使用 production
      # 当前节点应该是 550
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/os-specific/linux/nvidia-x11/default.nix
    };
  };
  environment = {
    systemPackages = with pkgs; [
      nvidia-vaapi-driver
      nv-codec-headers-12
      nvtopPackages.full
    ];
  };
}

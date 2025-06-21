{
  pkgs,
  lib,
  self,
  ...
}:
{
  imports = [ "${self}/modules/Hardware/acceleration.nix" ];
  boot.kernelParams = [ "intel_iommu=on" ];
  hardware = {
    cpu.intel.updateMicrocode = true;
    intel-gpu-tools.enable = true;
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = lib.mkDefault "iHD";
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };
}

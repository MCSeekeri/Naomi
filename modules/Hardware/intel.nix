{ pkgs, ... }:
{
  hardware = {
    cpu.intel.updateMicrocode = true;
    intel-gpu-tools.enable = true;
    graphics = {
      extraPackages = [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = pkgs.driversi686Linux.intel-vaapi-driver;
    };
  };
}

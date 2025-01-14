{ ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      # package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };
}

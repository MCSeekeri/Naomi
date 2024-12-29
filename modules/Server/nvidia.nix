{
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      datacenter.enable = false;
    };
  };
  services.xserver = {
    videoDrivers = [
      "nvidia"
      "modesetting"
      "fbdev"
    ];
  };
  programs.nix-required-mounts.presets.nvidia-gpu.enable = true;
}

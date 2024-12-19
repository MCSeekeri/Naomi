{
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;
      datacenter.enable = true;
    };
  };
}
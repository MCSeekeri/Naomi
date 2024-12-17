{
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      dynamicBoost.enable = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
  };
}
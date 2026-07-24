{ lib, ... }: {
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 10;
    memoryPercent = 75;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 150;
    "vm.page-cluster" = lib.mkDefault 0;
    "vm.watermark_boost_factor" = lib.mkDefault 0;
    "vm.watermark_scale_factor" = lib.mkDefault 125;
    "vm.vfs_cache_pressure" = lib.mkDefault 50;
  };
}

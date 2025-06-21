{
  boot = {
    loader = {
      # efi.canTouchEfiVariables = false;
      # 在部分 EFI 分区不可修改的设备上需要这个选项
      # efi.efiSysMountPoint = "/boot/EFI";
      systemd-boot = {
        enable = true;
        editor = false;
        # 启动的时候最多显示 20 个版本
        # 如果跑了 20 个配置文件还没修好 Bug，我建议你反思下
        configurationLimit = 20;
      };
    };
    tmp.cleanOnBoot = true;
    kernelParams = [
      "zswap.enabled=1"
      "zswap.max_pool_percent=50"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
    ];
    kernel.sysctl."kernel.sysrq" = 1;
    # PrtSc 或者 Fn+S
    # Alt+SysRq+f 触发 OOM Killer
    # 如果还救不回来，那就 Reboot Even If System Utterly Broken
  };
}

{ pkgs, ...}:
{
  boot = {
    loader = {
      # efi.canTouchEfiVariables = false;
      # 在部分 EFI 分区不可修改的设备上需要这个选项
      efi.efiSysMountPoint = "/boot/EFI";
      systemd-boot = {
        enable = true;
        editor = false;
        # 启动的时候最多显示 20 个版本
        # 如果跑了 20 个配置文件还没修好 Bug，我建议你反思下
        configurationLimit = 20;
      };
    };
  };
}
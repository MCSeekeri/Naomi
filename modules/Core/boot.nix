{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    # efi.canTouchEfiVariables = false;
    # 在部分 EFI 分区不可修改的设备上需要这个选项
    # efi.efiSysMountPoint = "/boot/EFI";
    lanzaboote = {
      # 基本上和 systemd-boot 是一回事，不过添加了安全启动支持
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # 启动的时候最多显示 20 个版本
      # 如果跑了 20 个配置文件还没修好 Bug，我建议你反思下
      configurationLimit = 20;
    };
    tmp.cleanOnBoot = true;
    kernel.sysctl = lib.mkDefault {
      "kernel.sysrq" = 1;
      # PrtSc 或者 Fn+S
      # Alt+SysRq+f 触发 OOM Killer
      # 如果还救不回来，那就 Reboot Even If System Utterly Broken
      "vm.max_map_count" = 2147483642;
      "kernel.panic" = 15; # 内核恐慌 15 秒之后重启
    };
    kernelParams = [ "boot.shell_on_fail" ];
  };
}

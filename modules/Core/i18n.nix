{ lib, ... }:
{
  i18n = {
    # 默认语言不要设置为中文，tty 下会出大悲剧
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault "zh_CN.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "zh_CN.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "zh_CN.UTF-8";
      LC_MONETARY = lib.mkDefault "zh_CN.UTF-8";
      LC_NAME = lib.mkDefault "zh_CN.UTF-8";
      LC_NUMERIC = lib.mkDefault "zh_CN.UTF-8";
      LC_PAPER = lib.mkDefault "zh_CN.UTF-8";
      LC_TELEPHONE = lib.mkDefault "zh_CN.UTF-8";
      LC_TIME = lib.mkDefault "zh_CN.UTF-8";
    };
    # 修改此项来实现多语言支持
    # *罐头笑声*
  };
  time = {
    timeZone = "Asia/Shanghai";
    hardwareClockInLocalTime = false; # 设置硬件时间为 UTC
  };
  networking.timeServers = [
    "cn.ntp.org.cn"
    "ntp.aliyun.com"
    "ntp1.aliyun.com"
    "ntp2.aliyun.com"
    "ntp3.aliyun.com"
    "ntp4.aliyun.com"
    "ntp.tuna.tsinghua.edu.cn"
  ];
}

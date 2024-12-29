{ pkgs, ... }:
{
  i18n = {
    # 默认语言不要设置为中文，tty 下会出大悲剧
    defaultLocale = "en_US.UTF-8";
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

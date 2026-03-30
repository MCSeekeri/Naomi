{ lib, ... }:
{
  i18n = {
    # 默认语言不要设置为中文，tty 下会出大悲剧
    defaultLocale = lib.mkDefault "en_US.UTF-8";
  };
  time = {
    timeZone = lib.mkDefault "UTC";
    hardwareClockInLocalTime = false; # 设置硬件时间为 UTC
  };
}

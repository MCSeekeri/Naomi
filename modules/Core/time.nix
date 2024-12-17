{
  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = false; # 设置硬件时间为 UTC
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
{ lib, self, ... }:
{
  # 没有想到什么合适的文件名
  # 基本上是国内环境特供的一些配置

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  time.timeZone = "Asia/Shanghai";

  networking.timeServers = [
    "cn.ntp.org.cn"
    "ntp.aliyun.com"
    "ntp1.aliyun.com"
    "ntp2.aliyun.com"
    "ntp3.aliyun.com"
    "ntp4.aliyun.com"
    "ntp.tuna.tsinghua.edu.cn"
  ];

  nix.settings.extra-substituters = lib.mkBefore [
    "https://mirrors.cernet.edu.cn/nix-channels/store?priority=1"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
    "https://mirror.sjtu.edu.cn/nix-channels/store?priority=3"
  ];

  services.flatpak.remotes = [
    {
      name = "flathub_sjtug";
      location = "https://mirror.sjtu.edu.cn/flathub/flathub.flatpakrepo";
    }
  ];

  home-manager.sharedModules = [ "${self}/modules/Home/prc.nix" ];
}

{ lib, config, ... }: {
  nix = {
    channel.enable = false;
    distributedBuilds = true;
    gc = lib.mkDefault {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d"; # 删除超过一周的垃圾文件，硬盘笑传之踩踩 Backup
    };
    settings = {
      auto-optimise-store = lib.mkDefault (!config.boot.isContainer);
      extra-substituters = [ "https://nix.mcseekeri.com?priority=51" ];
      extra-trusted-public-keys = lib.mkDefault [
        "nix.mcseekeri.com-1:3gd0/2u7IOF7YooxEiBbWTvRCYGC53S2UoqFdnCUYHc="
      ];
      # 启动 Flake，勿动，除非你知道你在做什么
      # https://nixos.wiki/wiki/Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
      connect-timeout = 20;
      http-connections = 64;
      max-substitution-jobs = 32; # 加速下载
      max-free = 5 * 1024 * 1024 * 1024;
      min-free = 1024 * 1024 * 1024;
      builders-use-substitutes = true;
    };
    daemonCPUSchedPolicy = lib.mkDefault "idle"; # 确保在桌面环境下不影响用户体验
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonIOSchedPriority = lib.mkDefault 7;
  };
  # 允许非自由软件
  nixpkgs.config = {
    allowUnfree = true;
  };
}

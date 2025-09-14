{ lib, config, ... }:
{
  nix = {
    channel.enable = false;
    distributedBuilds = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d"; # 删除超过一周的垃圾文件，硬盘笑传之踩踩 Backup
    };
    settings = {
      auto-optimise-store = lib.mkDefault (!config.boot.isContainer);
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
        "https://cache.nixos.org/?priority=3"
        "https://nix-community.cachix.org?priority=4"
        "https://numtide.cachix.org?priority=5"
        "https://cache.garnix.io?priority=6"
        "https://cache.lix.systems?priority=7"
        "https://nix-gaming.cachix.org?priority=8"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      # 启动 Flake，勿动，除非你知道你在做什么
      # https://nixos.wiki/wiki/Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
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

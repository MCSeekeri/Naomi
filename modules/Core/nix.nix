{ lib, ... }:
{
  # 设置软件源
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d"; # 删除超过一周的垃圾文件，硬盘笑传之踩踩 Backup
    };
    settings = {
      auto-optimise-store = true; # 会让 build 变慢，见仁见智吧
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
        "https://cache.nixos.org/?priority=3"
        "https://cache.garnix.io?priority=4"
        "https://nix-community.cachix.org?priority=5"
        "https://numtide.cachix.org?priority=6"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
      # 启动 Flake，勿动，除非你知道你在做什么
      # https://nixos.wiki/wiki/Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" ];
      connect-timeout = 20;
      http-connections = 64;
      max-substitution-jobs = 32; # 加速下载
      max-free = 5 * 1024 * 1024 * 1024;
      min-free = 1024 * 1024 * 1024;
      builders-use-substitutes = true;
    };
  };
  # 允许非自由软件
  nixpkgs.config = {
    allowUnfree = true;
  };
}

{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
    # 需要用 modulesPath 避免纯评估模式出错，大概
  ];
  nixpkgs.hostPlatform = "x86_64-linux"; # 目前只考虑 x86_64

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  # 网络配置
  networking = {
    hostName = "cuba"; # 主机名，设置好之后最好不要修改
  };

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };

  boot.tmp = {
    # 很冒险的设置，等待后续测试
    useTmpfs = true;
    tmpfsSize = "75%";
  };

  nix = {
    settings = {
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
        "https://mirror.sjtu.edu.cn/nix-channels/store?priority=2"
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

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    # hashedPassword = "";
  };
  systemd = {
    # 以防万一
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

}

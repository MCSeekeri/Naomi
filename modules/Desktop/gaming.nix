{ pkgs, ... }: {

  programs = {
    steam = {
      enable = true;
      # extest.enable = true; # 容易漏环境，导致开了 Shell 之后一大堆 32 位 so 报错，得关……
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      # fontPackages = with pkgs; [ source-han-sans ];
      extraPackages = with pkgs; [
        gamescope
        mangohud
        gamemode
      ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };

  hardware = {
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };

  boot.kernel.sysctl = {
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
    "kernel.split_lock_mitigate" = 0;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    adwsteamgtk
    samrewritten
    steam-run
    steamtinkerlaunch
    ludusavi
    steam-tui
    steamcmd
    gamemode
  ];

  services = {
    udev.extraRules = ''
      # DualShock 4 (PS4)
      ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

      # DualSense (PS5)
      ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}

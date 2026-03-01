{ pkgs, inputs, ... }:
{
  imports = with inputs; [
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
  ];

  programs = {
    steam = {
      enable = true;
      # extest.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      gamescopeSession.enable = true;
      # fontPackages = with pkgs; [ source-han-sans ];
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
  environment.systemPackages = with pkgs; [
    mangohud
    adwsteamgtk
    samrewritten
    steam-run
    steamtinkerlaunch
    ludusavi
    samrewritten
    steam-tui
    steamcmd
    gamemode
  ];

  services = {
    pipewire.lowLatency.enable = true;
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

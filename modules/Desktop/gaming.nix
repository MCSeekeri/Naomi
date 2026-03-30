{ pkgs, inputs, ... }:
{
  imports = with inputs; [
    nix-gaming.nixosModules.pipewireLowLatency
    nix-gaming.nixosModules.platformOptimizations
  ];

  # Steam 版本的地平线 4 扳机震动，你在哪里……
  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages_zen = prev.linuxPackages_zen.extend (
        _kernelFinal: kernelPrev: {
          xpadneo = kernelPrev.xpadneo.overrideAttrs {
            version = "0.10";
            patches = [ ];
            src = final.fetchFromGitHub {
              owner = "atar-axis";
              repo = "xpadneo";
              tag = "v0.10";
              hash = "sha256-jIY7NzjVZMlJ+2EY4hrka1MBUalQiNWzQgW2aiNi7WU=";
            };
          };
        }
      );
    })
  ];

  programs = {
    steam = {
      enable = true;
      # extest.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      platformOptimizations.enable = true;
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

{ pkgs, inputs, ... }:
{
  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
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
  ];

  services.pipewire.lowLatency.enable = true;
  programs.steam.platformOptimizations.enable = true;
}

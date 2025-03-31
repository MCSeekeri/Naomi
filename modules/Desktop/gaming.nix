{ pkgs, ... }:
{

  programs = {
    steam = {
      enable = true;
      extest.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
      fontPackages = with pkgs; [ source-han-sans ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };
  hardware = {
    xpadneo.enable = true;
  };
  environment.systemPackages = with pkgs; [
    mangohud
    adwsteamgtk
    samrewritten
  ];
}

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
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
    gamemode.enable = true;
  };
  hardware = {
    xpadneo.enable = true;
  };
}

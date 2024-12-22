{
  programs = {
    steam = {
      enable = true;
      extest.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
      protontricks.enable = true;
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
  hardware = {
    xpadneo.enable = true;
  };
}

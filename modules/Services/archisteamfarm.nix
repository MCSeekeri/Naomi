{
  services.archisteamfarm = {
    enable = true;
    web-ui.enable = true;
    settings = {
      # ASF 会自动覆盖配置，所以必须写在这里
      ASFEnhance = {
        Statistic = false;
        AutoClaimItemBotNames = "ASF";
      };
    };
    bots = { }; # 在 WebUI 中配置，暂时不考虑预置。
  };
}

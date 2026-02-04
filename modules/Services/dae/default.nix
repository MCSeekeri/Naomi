{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.dae = {
    enable = true;
    assets = with pkgs; [
      v2ray-geoip
      v2ray-domain-list-community
      sing-geoip
      sing-geosite
    ];
    config = lib.mkDefault (builtins.readFile ./config.dae);
  };

  systemd.services.dae = lib.mkIf config.services.dae.enable {
    after = lib.optional (config.services.adguardhome.enable or false) "adguardhome.service";
    wants = lib.optional (config.services.adguardhome.enable or false) "adguardhome.service";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}

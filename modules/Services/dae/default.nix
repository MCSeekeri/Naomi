{ pkgs, ... }:
{
  services.dae = {
    enable = true;
    assets = with pkgs; [
      v2ray-geoip
      v2ray-domain-list-community
      sing-geoip
      sing-geosite
    ];
    config = builtins.readFile ./config.dae;
    # disableTxChecksumIpGeneric = true;
  };
}

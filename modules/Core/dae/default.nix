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
    openFirewall = {
      # 纯本机分流，暂时不考虑给路由透明代理
      enable = false;
      port = 12345;
    };
  };
}

{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "Naomi" = {
        credentialsFile = "${config.sops.secrets.cloudflared-creds.path}"; # 有点问题，之后修
        default = "http_status:404";
      };
    };
  };
  sops.secrets.cloudflared-creds = {
    sopsFile = ../../secrets/services.yaml;
    owner = "cloudflared";
    group = "cloudflared";
  };
}

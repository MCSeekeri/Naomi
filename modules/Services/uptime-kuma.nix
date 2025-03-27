{
  config,
  lib,
  self,
  ...
}:

{
  services.uptime-kuma = {
    enable = true;
    settings = {
      UPTIME_KUMA_CLOUDFLARED_TOKEN = "$(cat ${
        config.sops.secrets."cf-token-${config.networking.hostName}".path
      })";
    };
  };

  sops.secrets."cf-token-${config.networking.hostName}" = {
    sopsFile = "${self}/secrets/services/uptime-kuma.yaml";
    neededForUsers = true;
  };
}

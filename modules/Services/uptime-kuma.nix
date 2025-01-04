{ config, ... }:
{
  services.uptime-kuma = {
    enable = true;
    # settings = {
    #   UPTIME_KUMA_CLOUDFLARED_TOKEN = "$(cat ${config.sops.secrets.uptime-kuma-cf-token.path})";
    # };
    # 我之后再修好这个
  };
  # sops.secrets.uptime-kuma-cf-token = {
  #   sopsFile = ../../secrets/services.yaml;
  #   neededForUsers = true;
  # };
}

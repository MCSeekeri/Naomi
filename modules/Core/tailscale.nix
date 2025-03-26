{ config, ... }:
{
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = [ "--advertise-exit-node" ];
      openFirewall = true;
      authKeyFile = "${config.sops.secrets."auth-key".path}";
    };
  };
  # 90 天一换，别忘记了……
  sops.secrets."auth-key" = {
    sopsFile = ../../secrets/services/tailscale.yaml;
  };
}

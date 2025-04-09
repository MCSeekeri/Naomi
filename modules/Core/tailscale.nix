{ config, self, ... }:
{
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = [ "--advertise-exit-node" ];
      openFirewall = true;
      authKeyFile = config.sops.secrets."auth-key".path;
    };
  };
  # 90 天一换，别忘记了……
  sops.secrets."auth-key" = {
    sopsFile = "${self}/secrets/services/tailscale.yaml";
  };
  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };
}

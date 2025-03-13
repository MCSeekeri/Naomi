{ lib, ... }:
{
  services.resolved.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 5353 ];
  };
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = lib.mkDefault "yes";
    "99-wireless-client-dhcp".networkConfig.MulticastDNS = lib.mkDefault "yes";
  };
}

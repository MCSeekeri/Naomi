{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Containers/AquaDX" ];
  services.nginx = {
    virtualHosts."aquadx" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 4173;
        }
      ];
      root = pkgs.aquanet;

      locations."/aqua/" = {
        proxyPass = "http://100.100.20.1/";
      };

      locations."/d/" = {
        proxyPass = "https://aquadx.net/d/";
      };

    };
  };

  networking.firewall.allowedTCPPorts = [ 4173 ];
}

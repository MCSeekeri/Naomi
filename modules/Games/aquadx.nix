{ pkgs, ... }:
{
  imports = [
    ../Containers/AquaDX
  ];
  services.nginx = {
    virtualHosts."aquadx" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 4173;
        }
      ];
      root = (pkgs.callPackage ../../pkgs/aquanet { });

      locations."/aqua/" = {
        proxyPass = "http://100.100.20.1/";
        proxySetHeader = {
          Host = "$host";
          X-Real-IP = "$remote_addr";
          X-Forwarded-For = "$proxy_add_x_forwarded_for";
          X-Forwarded-Proto = "$scheme";
        };
      };

      locations."/d/" = {
        proxyPass = "https://aquadx.net/d/";
        proxySetHeader = {
          Host = "aquadx.net";
          X-Real-IP = "$remote_addr";
          X-Forwarded-For = "$proxy_add_x_forwarded_for";
          X-Forwarded-Proto = "https";
        };
       };

    };
  };

  networking.firewall.allowedTCPPorts = [ 4173 ];
}
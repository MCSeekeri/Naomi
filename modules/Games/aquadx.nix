{ pkgs, ... }:
{
  imports = [
    ../Containers/AquaDX
  ];
  services.nginx = {
    virtualHosts."localhost" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 4173;
        }
      ];
      root = (pkgs.callPackage ../../pkgs/aquanet { });
    };
  };

  networking.firewall.allowedTCPPorts = [ 4173 ];
}

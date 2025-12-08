{ config, lib, pkgs, ... }:

{
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "ghostchu/peerbanhelper:v9.1.5";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [ "--network=host" ];
  };
}

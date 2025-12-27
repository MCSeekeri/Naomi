{
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "ghostchu/peerbanhelper:v9.2.3";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [ "--network=host" ];
  };
}

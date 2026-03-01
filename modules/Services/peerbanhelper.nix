{
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "ghostchu/peerbanhelper:v9.3.6";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [ "--network=host" ];
  };
}

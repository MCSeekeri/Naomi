{
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "ghostchu/peerbanhelper:v9.2.5";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [ "--network=host" ];
  };
}

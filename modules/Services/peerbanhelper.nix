{
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "docker.io/ghostchu/peerbanhelper:latest";
    labels."io.containers.autoupdate" = "registry";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [ "--network=host" ];
  };
}

{
  virtualisation.arion.projects.peerbanhelper = {
    serviceName = "peerbanhelper";
    settings = {
      services.peerbanhelper.service = {
        image = "ghostchu/peerbanhelper:v7.4.5";
        ports = [ "9898:9898" ];
        restart = "unless-stopped";
        volumes = [ "pbh_data:/app/data" ];
      };

      docker-compose.volumes = {
        pbh_data = { };
      };
    };
  };
}

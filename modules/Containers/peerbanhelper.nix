{
  virtualisation.arion.projects.peerbanhelper = {
    serviceName = "peerbanhelper";
    settings = {
      services.peerbanhelper.service = {
        image = "ghostchu/peerbanhelper:v9.0.10";
        network_mode = "host";
        ports = [ "9898:9898" ];
        restart = "unless-stopped";
        volumes = [ "pbh_data:/app/data" ];
        environment = {
          PUID = 0;
          PGID = 0;
          TZ = "UTC";
        };
      };

      docker-compose.volumes = {
        pbh_data = { };
      };
    };
  };
}

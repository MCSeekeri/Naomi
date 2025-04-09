{
  systemd.services.grafana = {
    after = [ "network.target" ];
    wants = [ "network.target" ];
  };
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 4300;
          domain = "127.0.0.1";
          addr = "";
          serve_from_sub_path = true;
        };
      };
      provision.enable = true;
    };
    prometheus = {
      enable = true;
      port = 4301;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
      };
    };
    loki = {
      enable = true;
      configFile = ./loki-config.yaml;
    };
  };
}

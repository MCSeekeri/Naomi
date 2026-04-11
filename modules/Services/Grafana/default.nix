{ config, self, ... }:
{
  # 服务器
  #
  # services.prometheus.scrapeConfigs = [
  #   {
  #     job_name = "node";
  #     static_configs = [
  #       {
  #         labels.host = "galzburg";
  #         targets = [ "127.0.0.1:9091" ];
  #       }
  #       {
  #         labels.host = "cyprus";
  #         targets = [ "[]:9091" ];
  #       }
  #     ];
  #   }
  # ];

  services = {
    grafana = {
      enable = true;
      settings = {
        log = {
          level = "warn";
          mode = "console";
        };
        security = {
          admin_password = "$__file{${config.sops.secrets.grafana_admin_password.path}}";
        };
        server = {
          http_port = 4300;
        };
      };
      provision = {
        datasources.settings = {
          datasources = [
            {
              isDefault = true;
              name = "Prometheus";
              type = "prometheus";
              uid = "prometheus";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
            {
              name = "Loki";
              type = "loki";
              uid = "loki";
              url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ];
        };
      };
    };
    prometheus = {
      enable = true;
    };

    loki = {
      enable = true;
      configuration = {
        auth_enabled = false;
        common = {
          path_prefix = "/var/lib/loki";
          replication_factor = 1;
          ring = {
            instance_addr = "127.0.0.1";
            kvstore.store = "inmemory";
          };
        };
        compactor = {
          compaction_interval = "10m";
          delete_request_store = "filesystem";
          retention_enabled = true;
          working_directory = "/var/lib/loki/compactor";
        };
        limits_config = {
          retention_period = "336h";
        };
        schema_config.configs = [
          {
            from = "2026-01-01"; # 只是普通的时间设置，没有什么深意
            index = {
              period = "24h";
              prefix = "index_";
            };
            object_store = "filesystem";
            schema = "v13";
            store = "tsdb";
          }
        ];
        server = {
          http_listen_port = 9092;
          log_level = "warn";
        };
        storage_config = {
          filesystem.directory = "/var/lib/loki/chunks";
          tsdb_shipper = {
            active_index_directory = "/var/lib/loki/tsdb-index";
            cache_location = "/var/lib/loki/tsdb-cache";
          };
        };
      };
    };
  };

  sops.secrets.grafana_admin_password = {
    key = "admin_password";
    owner = "grafana";
    group = "grafana";
    sopsFile = "${self}/secrets/services/grafana.yaml";
  };
}

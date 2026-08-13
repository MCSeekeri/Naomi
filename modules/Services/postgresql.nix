{ config, lib, ... }: {
  services = {
    postgresql = {
      settings = {
        shared_buffers = lib.mkDefault "256MB";
        effective_cache_size = lib.mkDefault "1GB";
        maintenance_work_mem = lib.mkDefault "128MB";
        work_mem = lib.mkDefault "8MB";
        max_connections = lib.mkDefault 50;
        random_page_cost = lib.mkDefault 1.1;
        autovacuum_vacuum_scale_factor = lib.mkDefault 0.05;
        log_min_duration_statement = lib.mkDefault 500;
      };
    };

    postgresqlBackup = lib.mkIf config.services.postgresql.enable {
      enable = true;
      location = "/var/backup/postgresql";
      compression = "none";
    };
  };
}

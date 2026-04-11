_: {
  services.vaultwarden = {
    enable = true;
    configureNginx = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    # environmentFile = [ config.sops.secrets.vaultwarden_env.path ];
    # 基于环境变量的配置
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_LOG = "critical";
      ROCKET_PORT = 8222;
    };
  };
}

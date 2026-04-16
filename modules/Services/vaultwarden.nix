{ lib, ... }:
{
  services.vaultwarden = {
    enable = true;
    configureNginx = lib.mkDefault true;
    dbBackend = lib.mkDefault "sqlite";
    backupDir = lib.mkDefault "/var/backup/vaultwarden";
    # environmentFile = [ config.sops.secrets.vaultwarden_env.path ];
    # 基于环境变量的配置
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_LOG = "critical";
      ROCKET_PORT = 8222;
    };
  };
}

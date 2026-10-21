{ lib, ... }: {
  services.vaultwarden = {
    enable = true;
    configureNginx = lib.mkDefault false;
    backupDir = lib.mkDefault "/var/backup/vaultwarden";
    # environmentFile = [ config.sops.secrets.vaultwarden_env.path ];
    # 基于环境变量的配置
    config = {
      SIGNUPS_ALLOWED = false;
      ROCKET_LOG = "critical";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };
}

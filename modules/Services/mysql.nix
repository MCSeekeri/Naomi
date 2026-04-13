{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = lib.optionals config.services.mysql.enable [ pkgs.mycli ];

  services = {
    mysql = {
      enable = lib.mkDefault true;
      package = pkgs.mariadb;
      settings.mysqld.bind-address = lib.mkDefault [
        "127.0.0.1"
        "172.17.0.1" # [TODO] 检查容器是否能访问到
      ];
    };

    mysqlBackup = lib.mkIf config.services.mysql.enable {
      enable = true;
      location = "/var/backup/mysql";
      calendar = "03:00:00";
      compressionAlg = "zstd";
      compressionLevel = 19; # 能省一点硬盘是一点……算力又不值钱
    };
  };
}

{ pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.mycli ];

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings = lib.mkDefault {
        mysqld = {
          bind-address = [
            "127.0.0.1"
            "172.17.0.1" # [TODO] 检查容器是否能访问到
          ];
        };
      };
    };

    mysqlBackup = {
      enable = true;
      location = "/var/backup/mysql";
      calendar = "03:00:00";
      compressionAlg = "zstd";
      compressionLevel = 19; # 能省一点硬盘是一点……算力又不值钱
    };
  };
}

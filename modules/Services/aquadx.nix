{
  config,
  pkgs,
  lib,
  ...
}:
# 我不知道这东西是怎么跑起来的，但它跑起来了。
# 恐怖。
# [TODO] 检查是否能够数据持久化保存。
let
  cfg = config.services.aquadx;
in
{
  options.services.aquadx = {
    enable = lib.mkEnableOption "aquadx";
    package = lib.mkPackageOption pkgs "aquadx" { };
    configFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to AquaDX service configuration file";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open firewall ports";
    };
    database = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "MariaDB database host address";
      };
      port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = "MariaDB database port";
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "aquadx";
        description = "Database name";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "aquadx";
        description = "Database username";
      };
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to automatically create local database";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      8443
      22345
    ];

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      package = pkgs.mariadb;
      initialDatabases = [ { inherit (cfg.database) name; } ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.aquadx.database = lib.mkMerge [
      (lib.mkIf cfg.database.createLocally {
        host = lib.mkDefault "localhost";
        port = lib.mkDefault 3306;
      })
    ];

    users.users.${cfg.database.user} = {
      group = "aquadx";
      isSystemUser = true;
    };

    users.groups.${cfg.database.user} = { };

    systemd = {
      tmpfiles.rules = [
        "d /var/cache/aquadx 0700 ${cfg.database.user} ${cfg.database.user}"
        "d /var/cache/aquadx/config 0700 ${cfg.database.user} ${cfg.database.user}"
      ];

      services.aquadx = {
        wantedBy = [ "multi-user.target" ];

        environment = {
          SPRING_DATASOURCE_URL = "jdbc:mariadb://${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}?localSocket=/var/run/mysqld/mysqld.sock";
          SPRING_DATASOURCE_USERNAME = cfg.database.user;
          SPRING_DATASOURCE_DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
        };

        serviceConfig = {
          ExecStartPre = ''
            ${pkgs.coreutils}/bin/cp ${cfg.configFile} /var/cache/aquadx/config/application.properties
          '';
          ExecStart = [ "${pkgs.jdk21_headless}/bin/java -jar ${cfg.package}/AquaDX-1.0.0.jar" ];
          Restart = "on-failure";
          RestartSec = "3s";
          User = cfg.database.user;
          Group = cfg.database.user;
          WorkingDirectory = "/var/cache/aquadx";
          RuntimeDirectory = "aquadx";
          StateDirectory = "aquadx";
          RuntimeDirectoryMode = "0700";
          SecureBits = "keep-caps";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE CAP_NET_ADMIN";
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_NET_ADMIN";
        };
      };
    };
    assertions = [
      {
        assertion = !(cfg.database.host == null && !cfg.database.createLocally);
        message = ''
          Either `createLocally` or `host` should be set.
        '';
      }
    ];
  };
}

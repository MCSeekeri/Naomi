{
  config,
  lib,
  self,
  pkgs,
  ...
}:
{
  imports = [ "${self}/modules/Services/mysql.nix" ];

  options.services.openlist = {
    enable = lib.mkEnableOption "是否启用 OpenList";

    instances = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              domain = lib.mkOption {
                type = lib.types.str;
                description = "此实例的域名";
              };

              port = lib.mkOption {
                type = lib.types.port;
                description = "此实例监听的端口";
              };

              stateDirectory = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "(可选)此实例的状态目录";
              };

              dbTablePrefix = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "(可选)此实例的数据库表前缀";
              };

              meilisearchIndex = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "(可选)此实例的 Meilisearch 索引名";
              };
            };
          }
        )
      );
      default = { };
      description = "OpenList 实例配置";
    };
  };

  config = lib.mkIf config.services.openlist.enable {
    systemd.services = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair name {
        description = "OpenList Service for ${instance.domain}";
        after = [
          "network-online.target"
        ]
        ++ lib.optional config.services.mysql.enable "mysql.service"
        ++ lib.optional config.services.meilisearch.enable "meilisearch.service";
        wants = [
          "network-online.target"
        ]
        ++ lib.optional config.services.mysql.enable "mysql.service"
        ++ lib.optional config.services.meilisearch.enable "meilisearch.service";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.openlist}/bin/OpenList server";
          WorkingDirectory = "/var/lib/${instance.stateDirectory}";

          User = "openlist";
          Group = "openlist";

          EnvironmentFile = config.sops.secrets.openlist_env.path;
          Environment = [
            "OPENLIST_SITE_URL=https://${instance.domain}"
            "OPENLIST_HTTP_PORT=${toString instance.port}"
            "OPENLIST_MEILISEARCH_INDEX=${instance.meilisearchIndex}"
          ]
          ++ lib.optional (
            instance.dbTablePrefix != null
          ) "OPENLIST_DB_TABLE_PREFIX=${instance.dbTablePrefix}";
          StateDirectory = instance.stateDirectory;
          Restart = "on-failure";

          ProtectSystem = "strict";
          ReadWritePaths = [ "/var/lib/${instance.stateDirectory}" ];
          BindReadOnlyPaths = lib.optionals config.services.mysql.enable [ "/run/mysqld" ];

          MountAPIVFS = true;

          UMask = "0077";
          ProtectHome = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";

          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateUsers = true;
          PrivateMounts = true;
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          LockPersonality = true;
          RemoveIPC = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
            "~@reboot"
            "~@obsolete"
          ];
          CapabilityBoundingSet = "";

          MemoryDenyWriteExecute = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
        };
      }
    ) config.services.openlist.instances;

    services = {
      meilisearch = {
        enable = lib.mkDefault true;
        masterKeyFile = config.sops.secrets.masterKey.path;
      };
      mysql = lib.mkIf config.services.mysql.enable {
        ensureDatabases = [ "openlist" ];
        ensureUsers = [
          # 用 Unix Socket 的好处是不需要设置密码，坏处是没有密码……
          {
            name = "openlist";
            ensurePermissions = {
              "openlist.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };
      nginx.enable = lib.mkDefault true;
      nginx.virtualHosts = lib.mkIf config.services.nginx.enable (
        lib.mapAttrs' (
          _: instance:
          lib.nameValuePair instance.domain {
            forceSSL = true;
            useACMEHost = instance.domain;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString instance.port}";

              extraConfig = ''
                proxy_set_header Range $http_range;
                proxy_set_header If-Range $http_if_range;

                client_max_body_size 20000m;
              '';
            };
          }
        ) config.services.openlist.instances
      );
    };

    users.users.openlist = {
      isSystemUser = true;
      group = "openlist";
    };
    users.groups.openlist = { };
  };
}

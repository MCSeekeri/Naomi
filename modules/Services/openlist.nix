{
  config,
  lib,
  self,
  pkgs,
  ...
}:
{
  imports = [ "${self}/modules/Services/mysql.nix" ];

  systemd.services.openlist = {
    description = "OpenList Service";
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
      WorkingDirectory = "/var/lib/openlist";

      User = "openlist";
      Group = "openlist";

      EnvironmentFile = config.sops.secrets.openlist_env.path; # 手工配置！
      StateDirectory = "openlist";
      Restart = "on-failure";

      ProtectSystem = "strict";
      ReadWritePaths = [ "/var/lib/openlist" ];
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
  };

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
    nginx = {
      virtualHosts = lib.mkIf config.services.nginx.enable {
        "pan.mcseekeri.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:25478";

            extraConfig = ''
              proxy_set_header Range $http_range;
              proxy_set_header If-Range $http_if_range;

              client_max_body_size 20000m;
            '';
          };
        };
      };
    };
  };

  users.users.openlist = {
    isSystemUser = true;
    group = "openlist";
  };
  users.groups.openlist = { };
}

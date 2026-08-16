{ lib }:
lib.extend (
  final: _prev: {
    isDesktop =
      config:
      (config.services.xserver.enable or false)
      || (config.programs.niri.enable or false)
      || (config.services.desktopManager.plasma6.enable or false);

    mkWordpressPhpPools =
      { pkgs, names }:
      let
        pool = {
          user = "wordpress";
          group = "wordpress";
          phpPackage = pkgs.php.withExtensions (
            { all, ... }: with all;
            [
              bcmath
              calendar
              curl
              ctype
              dom
              exif
              fileinfo
              filter
              ftp
              gd
              gettext
              gmp
              iconv
              intl
              ldap
              mbstring
              mysqli
              mysqlnd
              openssl
              pcntl
              pdo
              pdo_mysql
              pdo_odbc
              pdo_pgsql
              pdo_sqlite
              pgsql
              posix
              readline
              session
              simplexml
              sockets
              soap
              sodium
              sysvsem
              sqlite3
              tokenizer
              xmlreader
              xmlwriter
              zip
              zlib
              opcache
              redis
            ]
          );
          settings = {
            "listen.owner" = "wordpress";
            "listen.group" = "caddy";
            "listen.mode" = "0660";
            "pm" = "ondemand";
            "pm.max_children" = 4;
            "pm.process_idle_timeout" = "10s";
            "pm.max_requests" = 500;
          };
          phpOptions = ''
            memory_limit = 256M
            upload_max_filesize = 64M
            post_max_size = 64M
            max_execution_time = 300
          '';
        };
      in
      final.genAttrs names (_: pool);

    hardenedServiceConfig = {
      LockPersonality = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
        "~@resources"
        "~@reboot"
        "~@obsolete"
      ];
      UMask = "0077";
    };

    mkResticBackup =
      {
        repository,
        passwordFile,
        environmentFile,
        paths,
        tag,
      }:
      {
        initialize = true;
        inherit
          repository
          passwordFile
          environmentFile
          paths
          ;
        extraBackupArgs = [
          "--tag ${tag}"
          "--compression max"
          "--skip-if-unchanged"
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];
        checkOpts = [
          "--with-cache"
          "--read-data-subset 5%"
        ];
        timerConfig = {
          OnCalendar = "04:00";
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
      };

  }
)

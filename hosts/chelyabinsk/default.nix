{
  config,
  lib,
  pkgs,
  self,
  modulesPath,
  ...
}:
{
  imports = [
    ./disko-config.nix
    (modulesPath + "/profiles/qemu-guest.nix")

    "${self}/modules/Core"
    "${self}/modules/Core/prc.nix"

    "${self}/modules/Server/podman.nix"
    "${self}/modules/Services/cloudflared.nix"
    "${self}/modules/Services/caddy.nix"
    "${self}/modules/Services/dae"
    "${self}/modules/Services/geph5.nix"
    "${self}/users/remote"
  ];

  networking = {
    hostName = "chelyabinsk";
    firewall.allowedTCPPorts = [ 6806 ];
  };
  boot = {
    tmp.useZram = false;
  };

  zramSwap = {
    memoryPercent = lib.mkForce 50;
    priority = lib.mkForce 10;
  };

  fileSystems."/swap" = {
    device = "/dev/vda2";
    fsType = "btrfs";
    options = [
      "subvol=swap"
      "noatime"
      "nofail"
    ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 2048;
      priority = 5;
    }
  ];

  hardware = {
    cpu.type = "qemu";
    deviceType = "server";
    enableAllFirmware = false;
  };

  system.stateVersion = "26.05";
  documentation.enable = false;
  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        });
      '';
    }; # wheel 权限无密码提权，非常不安全……
  };

  sops.secrets = {
    "forgejo-turnstile-sitekey" = {
      sopsFile = "${self}/secrets/hosts/chelyabinsk/forgejo.yaml";
    };
    "forgejo-turnstile-secret" = {
      sopsFile = "${self}/secrets/hosts/chelyabinsk/forgejo.yaml";
    };
    "siyuan-env" = {
      sopsFile = "${self}/secrets/hosts/chelyabinsk/siyuan.env";
      format = "dotenv";
      key = "";
    };
  };

  users.users.remote.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLrxsKjyzH3Ar+W0KqbpnJvMRtdF4PdPsNSiP9kv12m 2601677867@qq.com"
  ];

  users.users.deploy = {
    isNormalUser = true;
    home = "/var/www/remember11.com";
    group = "caddy";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7CFTArcv1HbYM+RI24Xh6ZlC7v2vZr+6EQC6cas6lm Github_Action"
    ];
    shell = pkgs.bash;
  };

  users.groups.wordpress.gid = 988;
  users.users.wordpress = {
    isSystemUser = true;
    uid = 33;
    group = "wordpress";
  };

  services = {
    forgejo = {
      enable = true;

      lfs.enable = true;

      database.type = "postgres";

      dump = {
        enable = true;
        backupDir = "/var/lib/forgejo/dump";
        interval = "daily";
        type = "tar.zst";
        age = "14d";
      };

      secrets = {
        service = {
          CF_TURNSTILE_SITEKEY = config.sops.secrets."forgejo-turnstile-sitekey".path;
          CF_TURNSTILE_SECRET = config.sops.secrets."forgejo-turnstile-secret".path;
        };
      };

      settings = {
        server = {
          DOMAIN = "git.exampletext.team";
          ROOT_URL = "https://git.exampletext.team/";

          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3000;
          SSH_PORT = 22;
          SSH_DOMAIN = "git.exampletext.team";

          OFFLINE_MODE = false;
        };

        repository = {
          DEFAULT_PRIVATE = "private";
        };

        "repository.upload" = {
          FILE_MAX_SIZE = 512;
          MAX_FILES = 20;
        };
        attachment = {
          MAX_SIZE = 2048;
          ALLOWED_TYPES = "*/*";
        };

        lfs = {
          LFS_HTTP_AUTH_EXPIRY = "24h";
        };

        mailer = {
          ENABLED = true;
          PROTOCOL = "sendmail";
          FROM = "forgejo@exampletext.team";
        };

        service = {
          DISABLE_REGISTRATION = false;

          ENABLE_CAPTCHA = true;
          CAPTCHA_TYPE = "cfturnstile";
          REQUIRE_CAPTCHA_FOR_LOGIN = true;
          REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA = true;

          DEFAULT_KEEP_EMAIL_PRIVATE = true;
        };
        cron = {
          ENABLED = true;
          RUN_AT_START = true;
        };
        "cron.git_gc_repos" = {
          ENABLED = true;
          RUN_AT_START = false;
          SCHEDULE = "@every 168h";
        };
      };
    };
    caddy = {
      openFirewall = true;
      virtualHosts = {
        "remember11.com" = {
          extraConfig = ''
            root * /var/www/remember11.com
            encode zstd gzip
            file_server
          '';
        };
        "pj31wiki.remember11.com" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy 127.0.0.1:6806
          '';
        };
        "fantrans.remember11.com" = {
          extraConfig = ''
            encode zstd gzip
            reverse_proxy 127.0.0.1:8081
          '';
        };
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [
        "transteam"
        "studio"
      ];
      ensureUsers = [
        {
          name = "wordpress";
          ensurePermissions = {
            "transteam.*" = "ALL PRIVILEGES";
            "studio.*" = "ALL PRIVILEGES";
          };
        }
      ];
      settings = {
        mysqld.skip-networking = true;
      };
    };
    journald.extraConfig = ''
      SystemMaxUse=200M
      MaxRetentionSec=1week
    '';

    redis.servers.wordpress = {
      enable = true;
      bind = null;
      port = 0;
      unixSocket = "/run/redis-wordpress/redis.sock";
      unixSocketPerm = 777;
    };
  };

  virtualisation.oci-containers.containers = {
    transteam = {
      image = "docker.io/library/wordpress:6";
      autoStart = true;
      ports = [ "127.0.0.1:8081:80" ];
      environment = {
        WORDPRESS_DB_HOST = "localhost:/var/run/mysqld/mysqld.sock";
        WORDPRESS_DB_USER = "wordpress";
        WORDPRESS_DB_NAME = "transteam";
        WORDPRESS_CONFIG_EXTRA = ''
          define('WP_AUTO_UPDATE_CORE', true);
          define('DISALLOW_FILE_EDIT', false);
          define('WP_CACHE', true);
          define('WP_REDIS_PATH', '/run/redis-wordpress/redis.sock');
          define('WP_REDIS_DATABASE', 0);
          define('WP_REDIS_TIMEOUT', 1);
          define('WP_REDIS_READ_TIMEOUT', 1);
        '';
      };
      volumes = [
        "/var/lib/wordpress/transteam/wp-content:/var/www/html/wp-content:Z"
        "/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock"
        "/run/redis-wordpress/redis.sock:/run/redis-wordpress/redis.sock"
      ];
      extraOptions = [ "--label=io.containers.autoupdate=registry" ];
    };

    studio = {
      image = "docker.io/library/wordpress:6";
      autoStart = true;
      ports = [ "127.0.0.1:8080:80" ];
      environment = {
        WORDPRESS_DB_HOST = "localhost:/var/run/mysqld/mysqld.sock";
        WORDPRESS_DB_USER = "wordpress";
        WORDPRESS_DB_NAME = "studio";
        WORDPRESS_CONFIG_EXTRA = ''
          define('WP_AUTO_UPDATE_CORE', true);
          define('DISALLOW_FILE_EDIT', false);
          define('WP_CACHE', true);
          define('WP_REDIS_PATH', '/run/redis-wordpress/redis.sock');
          define('WP_REDIS_DATABASE', 1);
          define('WP_REDIS_TIMEOUT', 1);
          define('WP_REDIS_READ_TIMEOUT', 1);
        '';
      };
      volumes = [
        "/var/lib/wordpress/studio/wp-content:/var/www/html/wp-content:Z"
        "/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock"
        "/run/redis-wordpress/redis.sock:/run/redis-wordpress/redis.sock"
      ];
      extraOptions = [ "--label=io.containers.autoupdate=registry" ];
    };

    siyuan = {
      image = "docker.io/b3log/siyuan:latest";
      autoStart = true;
      ports = [ "127.0.0.1:6806:6806" ];
      environment.TZ = "Asia/Shanghai";
      environmentFiles = [ config.sops.secrets."siyuan-env".path ];
      volumes = [ "/var/lib/siyuan:/siyuan/workspace:Z" ];
      cmd = [
        "--workspace=/siyuan/workspace/"
        "serve"
      ];
      extraOptions = [ "--label=io.containers.autoupdate=registry" ];
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d /var/www/remember11.com 0750 deploy caddy -"
      "d /var/lib/wordpress/transteam/wp-content 0755 root root -"
      "d /var/lib/wordpress/studio/wp-content 0755 root root -"
      "d /var/lib/siyuan 0755 root root -"
    ];
    services."podman-transteam" = {
      after = [ "mysql.service" ];
      requires = [ "mysql.service" ];
    };
    services."podman-studio" = {
      after = [ "mysql.service" ];
      requires = [ "mysql.service" ];
    };

    services."cloudflared-tunnel-chelyabinsk".environment.TUNNEL_TRANSPORT_PROTOCOL =
      lib.mkForce "http2"; # 哈哈，QUIC ……
  };
}

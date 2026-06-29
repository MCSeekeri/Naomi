{
  config,
  lib,
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
    "${self}/modules/Hardware"

    "${self}/modules/Server/podman.nix"
    "${self}/modules/Services/cloudflared.nix"
    "${self}/modules/Services/dae"
    "${self}/modules/Services/geph5.nix"
    "${self}/users/remote"
  ];

  networking.hostName = "chelyabinsk";

  boot = {
    loader = {
      grub.enable = true;
      limine.enable = false;
    };
    tmp.useZram = false;
  };
  zramSwap.enable = lib.mkForce false;

  hardware = {
    cpu.type = "qemu";
    deviceType = "server";
    enableAllFirmware = false;
  };

  system.stateVersion = "26.05";
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
  };

  users.users.remote.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLrxsKjyzH3Ar+W0KqbpnJvMRtdF4PdPsNSiP9kv12m 2601677867@qq.com"
  ];

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
  };
}

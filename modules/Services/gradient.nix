{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.services.gradient;
  env = cfg.environmentVariables;
in
{
  imports = [ ./postgresql.nix ];

  services = {
    gradient = {
      enable = true;
      nginx.enable = lib.mkDefault false;

      secrets = {
        jwtFile = config.sops.secrets.gradient_jwt.path;
        cryptFile = config.sops.secrets.gradient_crypt.path;
        s3SecretAccessKeyFile = config.sops.secrets.gradient_s3_secret_key.path;
      };

      postgres.enable = lib.mkDefault true;
    };

    caddy.virtualHosts.${cfg.domain} = {
      useACMEHost = cfg.domain;
      extraConfig = ''
        @backend path /api/* /cache/* /proto
        handle @backend {
          reverse_proxy http://${env.GRADIENT_LISTEN_ADDR}:${toString env.GRADIENT_PORT}
        }
        handle {
          root * ${cfg.packages.frontend}/share/gradient-frontend
          try_files {path} index.html
          file_server
        }
      '';
    };
  };

  sops.secrets = {
    gradient_jwt = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/gradient.yaml";
      key = "GRADIENT_JWT";
    };
    gradient_crypt = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/gradient.yaml";
      key = "GRADIENT_CRYPT";
    };
    gradient_admin_password = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/gradient.yaml";
      key = "GRADIENT_ADMIN_PASSWORD";
    };
    gradient_s3_secret_key = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/gradient.yaml";
      key = "GRADIENT_S3_SECRET_KEY";
    };
  };

  systemd.services.gradient-server = {
    serviceConfig = lib.serviceHardening {
      ReadWritePaths = lib.optional cfg.postgres.enable "/run/postgresql";
      ProcSubset = lib.mkForce "all";
    };
  };
}

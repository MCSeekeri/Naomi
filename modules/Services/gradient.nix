{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.gradient.nixosModules.default
    ./postgresql.nix
  ];

  services.gradient = {
    enable = true;
    proto.public = true;

    secrets = {
      jwtFile = config.sops.secrets.gradient_jwt.path;
      cryptFile = config.sops.secrets.gradient_crypt.path;
    };

    postgres.enable = true;

    s3 = {
      enable = true;
      secretAccessKeyFile = config.sops.secrets.gradient_s3_secret_key.path;
    };

    state = {
      delete = false;
      users.admin = {
        password_file = config.sops.secrets.gradient_admin_password.path;
        superuser = true;
      };
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
}

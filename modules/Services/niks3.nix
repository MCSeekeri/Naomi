{
  config,
  inputs,
  self,
  lib,
  ...
}:
{
  imports = [ inputs.niks3.nixosModules.niks3 ];

  services.niks3 = {
    enable = true;
    # httpAddr = "127.0.0.1:5751";

    apiTokenFile = config.sops.secrets.niks3_api_token.path;
    signKeyFiles = [ config.sops.secrets.niks3_signing_key.path ];

    database.createLocally = true;

    s3 = lib.mkDefault {
      # endpoint = "";
      # bucket = "nix";
      region = "auto";
      useSSL = true;
      accessKeyFile = config.sops.secrets.niks3_s3_access_key.path;
      secretKeyFile = config.sops.secrets.niks3_s3_secret_key.path;
    };
  };

  sops.secrets = {
    niks3_s3_access_key = {
      sopsFile = "${self}/secrets/services/niks3.yaml";
      key = "NIKS3_S3_ACCESS_KEY";
      owner = "niks3";
    };
    niks3_s3_secret_key = {
      sopsFile = "${self}/secrets/services/niks3.yaml";
      key = "NIKS3_S3_SECRET_KEY";
      owner = "niks3";
    };
    niks3_api_token = {
      sopsFile = "${self}/secrets/services/niks3.yaml";
      key = "NIKS3_API_TOKEN";
      owner = "niks3";
    };
    niks3_signing_key = {
      sopsFile = "${self}/secrets/services/niks3.yaml";
      key = "NIKS3_SIGNING_KEY";
      owner = "niks3";
    };
  };
}

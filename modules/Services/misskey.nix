{ config, lib, ... }: {
  imports = [ ./postgresql.nix ];

  services.misskey = {
    enable = true;
    # reverseProxy = {
    #   enable = true;
    #   host = "example.com";
    #   webserver.nginx = {
    #   };
    # };
    database.createLocally = true;
    meilisearch.createLocally = true;
    redis.createLocally = true;
  };

  systemd.services.misskey = {
    serviceConfig = lib.serviceHardening {
      ProcSubset = "all";
      ReadWritePaths =
        lib.optional config.services.misskey.database.createLocally "/run/postgresql"
        ++ lib.optional config.services.misskey.redis.createLocally "/run/redis-misskey";
    };
  };
}

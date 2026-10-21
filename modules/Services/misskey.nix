{ ... }: {
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
}

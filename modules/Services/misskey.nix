{ pkgs, ... }:
{
  services.misskey = {
    enable = true;
    package = pkgs.misskey;
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
  services.meilisearch.package = pkgs.meilisearch;
}

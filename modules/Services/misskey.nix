{ pkgs, ... }:
{
  services.misskey = {
    enable = true;
    package = pkgs.misskey;
    reverseProxy = {
      enable = true;
      host = "mcseekeri.com";
      ssl = false;
      webserver.nginx = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 6477;
          }
        ];
        locations = {
          "misskey" = {
            proxyPass = "http://localhost:3000";
            recommendedProxySettings = true;
          };
        };
      };
    };
    database.createLocally = true;
    meilisearch.createLocally = true;
    redis.createLocally = true;
    settings = {
      url = "https://mcseekeri.com";
      id = "aidx";
    };
  };
}

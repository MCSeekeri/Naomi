{ pkgs, ... }:
{
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust; # RIIR
    watchers = {
      aw-watcher-afk = {
        package = pkgs.aw-watcher-afk;
      };
      awatcher = {
        package = pkgs.awatcher;
      };
    };
  };
}

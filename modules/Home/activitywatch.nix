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

      # [TODO] 仍在寻找解决方案
      # https://github.com/2e3s/awatcher/issues/50
    };
  };
}

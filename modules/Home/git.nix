{ lib, ... }:
{
  programs = {
    git = {
      enable = lib.mkDefault true;
      settings = {
        push.autoSetupRemote = lib.mkDefault true;
        pull.rebase = lib.mkDefault true;
        log.date = lib.mkDefault "iso"; # 显而易见
        submodule.recurse = lib.mkDefault true; # 自动拉取子模块
      };
    };
    delta = {
      enable = lib.mkDefault true;
      options = {
        diff-so-fancy = lib.mkDefault true;
        line-numbers = lib.mkDefault true;
        true-color = lib.mkDefault "always";
      };
    };
  };
}

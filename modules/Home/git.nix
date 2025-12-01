{
  programs = {
    git = {
      enable = true;
      settings = {
        push.autoSetupRemote = true;
        pull.rebase = true;
        log.date = "iso"; # 显而易见
        submodule.recurse = true; # 自动拉取子模块
      };
    };
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
      };
    };
  };
}

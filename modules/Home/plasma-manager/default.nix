{
  imports = [
    ./fonts.nix
    ./powerdevil.nix
  ];

  programs = {
    plasma = {
      input.keyboard.numlockOnStartup = "on";
      kscreenlocker = {
        autoLock = true;
        lockOnResume = true;
        passwordRequired = true; # 显而易见
        # timeout = 2; # 分钟
      };
      kwin = {
        effects = {
          shakeCursor.enable = true; # 因为好玩，所以默认打开
        };
      };
      resetFilesExclude = [
        "baloofilerc"
        "kactivitymanagerd-statsrc" # 不这么设置的话，添加常用程序的时候会卡死。
      ];
      session = {
        general.askForConfirmationOnLogout = true;
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession"; # 不不不，不要看到上次开机干了啥
      };
      shortcuts = {
        "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      };
      hotkeys.commands = {
        kitty = {
          command = "kitty";
          key = "Ctrl+Alt+T";
        };
      };
      workspace = {
        clickItemTo = "select"; # 禁止历史倒车
        enableMiddleClickPaste = true;
      };
    };
  };
}

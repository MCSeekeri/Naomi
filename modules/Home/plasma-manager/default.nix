{ lib, ... }:
{
  imports = [
    ./fonts.nix
    ./powerdevil.nix
  ];

  gtk.gtk2.force = lib.mkDefault true;

  programs = {
    plasma = {
      input.keyboard.numlockOnStartup = lib.mkDefault "on";
      kscreenlocker = lib.mkDefault {
        autoLock = true;
        lockOnResume = true;
        passwordRequired = true; # 显而易见
        # timeout = 2; # 分钟
      };
      kwin = {
        effects = {
          shakeCursor.enable = lib.mkDefault true; # 因为好玩，所以默认打开
        };
      };
      resetFilesExclude = lib.mkDefault [
        "baloofilerc"
        "kactivitymanagerd-statsrc" # 不这么设置的话，添加常用程序的时候会卡死。
      ];
      session = {
        general.askForConfirmationOnLogout = lib.mkDefault true;
        sessionRestore.restoreOpenApplicationsOnLogin = lib.mkDefault "startWithEmptySession"; # 不不不，不要看到上次开机干了啥
      };
      shortcuts = lib.mkDefault { "kwin"."Kill Window" = "Meta+Ctrl+Esc"; };
      hotkeys.commands = lib.mkDefault {
        kitty = {
          command = "kitty";
          key = "Ctrl+Alt+T";
        };
        quake = {
          command = "kitten quick-access-terminal";
          key = "Shift+F12";
        };
      };
      workspace = {
        clickItemTo = lib.mkDefault "select"; # 禁止历史倒车
        enableMiddleClickPaste = lib.mkDefault true;
      };
    };
  };
}

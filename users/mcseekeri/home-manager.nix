{ pkgs, lib, ... }:

let
  lain-kde-splashscreen = pkgs.callPackage ../../pkgs/lain-kde-splashscreen { };
  defaultFont = {
    family = "Sarasa UI SC";
    pointSize = 13;
  };
in
{
  imports = [ ../../home/fcitx5 ];
  home = {
    username = "mcseekeri";
    homeDirectory = "/home/mcseekeri";
    stateVersion = "24.11";
    activation = {
      TideConfigure =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''run ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"'';
    };
    extraActivationPath = [ pkgs.babelfish ];

    packages = with pkgs; [
      #命令行
      fishPlugins.tide
      fishPlugins.done
      fishPlugins.autopair
      # fishPlugins.fish-you-should-use # 等写了一堆缩写之后再考虑
      # fishPlugins.sponge # 带来的问题比解决的问题多
      # 桌面应用
      librewolf
      ungoogled-chromium
      thunderbird
      xdg-desktop-portal
      xdg-dbus-proxy
      keepassxc
      kdePackages.xdg-desktop-portal-kde
      qq
      wpsoffice-cn
      motrix
      kdePackages.kdenlive
      anki-bin
      # 主题
      lain-kde-splashscreen
      kora-icon-theme
      dracula-icon-theme
      # 游戏娱乐
      moonlight-qt
      # 开发套件
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      micromamba
    ];
  };

  programs = {
    home-manager.enable = true;
    librewolf.languagePacks = [ "zh-CN" ];
    git = {
      enable = true;
      userName = "MCSeekeri";
      userEmail = "mcseekeri@outlook.com";
    };
    fish = {
      enable = true; # 比 zsh 更好，可惜不兼容 bash
      shellAliases = {
        conda = "micromamba";
        proxy = "proxychains4 -q";
      };
    };
    obs-studio = {
      enable = true;
    };
    plasma = {
      enable = true;
      overrideConfig = true;
      resetFilesExclude = [
        "baloofilerc"
        "kactivitymanagerd-statsrc" # 不这么设置的话，添加常用程序的时候会卡死。
      ];
      workspace = {
        # lookAndFeel = "Plasma-Overdose";
        enableMiddleClickPaste = true;
        clickItemTo = "select"; # 禁止历史倒车
        cursor.size = 36;
        splashScreen.theme = "Lain"; # I am falling, I am fading, I have lost it all
      };
      panels = [
        # ~/.config/plasma-org.kde.plasma.desktop-appletsrc
        {
          location = "bottom";
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config = {
                General = {
                  icon = "planetkde";
                  alphaSort = true;
                };
              };
            }
            "org.kde.plasma.pager"
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                  "applications:librewolf.desktop"
                ];
              };
            }
            {
              systemMonitor = {
                displayStyle = "org.kde.ksysguard.piechart";
                sensors = [
                  {
                    name = "cpu/all/usage";
                    color = "61,174,233";
                    label = "总 CPU 使用情况";
                  }
                ];
                totalSensors = [ "cpu/all/usage" ];
                textOnlySensors = [
                  "cpu/all/cpuCount"
                  "cpu/all/coreCount"
                ];
                settings = {
                  refreshInterval = 1000;
                };
              };
            }
            {
              systemMonitor = {
                displayStyle = "org.kde.ksysguard.piechart";
                sensors = [
                  {
                    name = "memory/physical/used";
                    color = "61,174,233";
                    label = "内存使用情况";
                  }
                ];
                totalSensors = [ "cpu/all/usage" ];
                textOnlySensors = [
                  "cpu/all/cpuCount"
                  "cpu/all/coreCount"
                ];
                settings = {
                  refreshInterval = 1000;
                };
              };
            }
            {
              systemMonitor = {
                displayStyle = "org.kde.ksysguard.textonly";
                sensors = [
                  {
                    name = "network/all/download";
                    color = "61,174,233";
                    label = "下载速率";
                  }
                  {
                    name = "network/all/upload";
                    color = "233,120,61";
                    label = "上传速率";
                  }
                ];
                settings = {
                  refreshInterval = 1000;
                };
              };
            }
            {
              systemMonitor = {
                displayStyle = "org.kde.ksysguard.textonly";
                sensors = [
                  {
                    name = "disk/all/write";
                    color = "61,174,233";
                    label = "写入速率";
                  }
                  {
                    name = "disk/all/read";
                    color = "233,120,61";
                    label = "读取速率";
                  }
                ];
                settings = {
                  refreshInterval = 1000;
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.notifications"
                ];
                hidden = [ ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "monday";
                time.format = "24h";
                time.showSeconds = "always";
              };
            }
            "org.kde.plasma.showdesktop"
          ];
          height = 60;
        }
      ];
      kwin = {
        virtualDesktops.number = 2;
        virtualDesktops.rows = 2;
        effects = {
          shakeCursor.enable = true;
        };
      };
      session = {
        general.askForConfirmationOnLogout = true;
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession"; # 不不不，不要看到上次开机干了啥
      };
      input.keyboard.numlockOnStartup = "on";
      powerdevil = {
        battery = {
          dimDisplay = {
            idleTimeout = 60;
          };
          turnOffDisplay = {
            idleTimeout = 180;
            idleTimeoutWhenLocked = 60;
          };
          autoSuspend.idleTimeout = 180;
          powerProfile = "balanced";
        };
      };
      kscreenlocker = {
        autoLock = true;
        lockOnResume = true;
        passwordRequired = true; # 显而易见
        timeout = 2;
      };
      fonts = {
        # 重复设置太多，抽象一下
        general = defaultFont;
        fixedWidth = {
          inherit (defaultFont) pointSize;
          family = "Sarasa Mono SC";
        };
        small = {
          inherit (defaultFont) family;
          pointSize = 11;
        };
        toolbar = defaultFont;
        menu = defaultFont;
        windowTitle = defaultFont;
      };
      shortcuts = {
        "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      };
      configFile = {
        "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = true;
        "kcminputrc"."Mouse"."XLbInptPointerAcceleration" = 0.4;
        "kdeglobals"."DialogIcons"."Size" = 48;
        "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "1292,596";
        "kdeglobals"."General"."BrowserApplication" = "librewolf.desktop";
        "kdeglobals"."General"."XftAntialias" = true;
        "kdeglobals"."General"."XftHintStyle" = "hintfull";
        "kdeglobals"."General"."XftSubPixel" = "rgb";
        "kdeglobals"."KFileDialog Settings"."Allow Expansion" = true;
        "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = false;
        "kdeglobals"."KFileDialog Settings"."Show Preview" = true;
        "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
        "kdeglobals"."KFileDialog Settings"."Show hidden files" = true;
        "kdeglobals"."KFileDialog Settings"."Sort by" = "Date";
        "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
        "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
        "kdeglobals"."KFileDialog Settings"."Sort reversed" = true;
        "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
        "kiorc"."Confirmations"."ConfirmDelete" = true;
        "kiorc"."Confirmations"."ConfirmEmptyTrash" = true;
        "kiorc"."Executable scripts"."behaviourOnLaunch" = "execute";
        "klipperrc"."General"."IgnoreImages" = false; # 剪切板，伟大，无需多言
        "klipperrc"."General"."MaxClipItems" = 150;
        "krunnerrc"."PlasmaRunnerManager"."migrated" = true;
        "krunnerrc"."Plugins"."baloosearchEnabled" = true;
        "kwinrc"."Wayland"."InputMethod" = {
          value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
        "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
        "kwinrc"."Xwayland"."Scale" = 1.25; # 适合这年头常见的 2560x1440 屏幕
        "kwinrc"."Xwayland"."XwaylandEavesdrops" = "Modifiers";
        # "kxkbrc"."Layout"."Options" = "terminate:ctrl_alt_bksp"; # Nuclear
        "plasma-localerc"."Formats"."LANG" = "zh_CN.UTF-8";
        "plasma-localerc"."Translations"."LANGUAGE" = "zh_CN";
        "plasmaparc"."General"."RaiseMaximumVolume" = true;
      };
      dataFile = {
        "dolphin/view_properties/global/.directory"."Dolphin"."SortOrder" = 1;
        "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
        "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
        "dolphin/view_properties/global/.directory"."Dolphin"."VisibleRoles" =
          "Icons_text,Icons_size,Icons_modificationtime,Icons_type,CustomizedDetails,Details_text,Details_type,Details_size,Details_modificationtime,Details_creationtime,Details_destination";
        "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
      };
    };

  };
  services = {
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };
  # TODO: 外观微调，常见软件的预配置
}

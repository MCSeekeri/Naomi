{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  defaultFont = {
    family = "Sarasa UI SC";
    pointSize = 13;
  };
in
{
  imports = [ ../../modules/Home/fcitx5 ];
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
      # 桌面应用
      thunderbird
      keepassxc
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
      uv
    ];
  };

  programs = {
    home-manager.enable = true;
    librewolf = {
      enable = true;
      # package = pkgs.librewolf;
      languagePacks = [ "zh-CN" ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = { };
      };
      profiles = {
        mcseekeri = {
          settings = {
            "extensions.autoDisableScopes" = 0;
            "privacy.resistFingerprinting.letterboxing" = true;
            "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          };
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
            # https://discourse.nixos.org/t/firefox-extensions-with-home-manager/34108/4
            ublock-origin
            violentmonkey
            kiss-translator
            # aw-watcher-web
            multi-account-containers
            private-relay
            temporary-containers
            keepassxc-browser
            steam-database
          ];
        };
      };
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "jinjaccalgkegednnccohejagnlnfdag"; } # violentmonkey
        { id = "fpeoodllldobpkbkabpblcfaogecpndd"; } # Webrecoder
        { id = "pfnededegaaopdmhkdmcofjmoldfiped"; } # ZeroOmega
        { id = "chphlpgkkbolifaimnlloiipkdnihall"; } # OneTab
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        { id = "eaoelafamejbnggahofapllmfhlhajdd"; } # B站空降助手
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
        { id = "mafpmfcccpbjnhfhjnllmmalhifmlcie"; } # ...
        { id = "bpoadfkcbjbfhfodiogcnhhhpibjhbnh"; } # 沉浸式翻译
        { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Integration
        { id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"; } # SteamDB
      ];
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-marketplace; [
        activitywatch.aw-watcher-vscode
        alibaba-cloud.tongyi-lingma
        dracula-theme.theme-dracula
        esbenp.prettier-vscode
        huacnlee.autocorrect
        mhutchie.git-graph
        ms-ceintl.vscode-language-pack-zh-hans
        ms-vscode-remote.remote-ssh
        ms-vscode.remote-explorer
        pinage404.nix-extension-pack
        redhat.vscode-xml
        redhat.vscode-yaml
        usernamehw.errorlens
        vivaxy.vscode-conventional-commits
      ];
    };
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
          powerButtonAction = "shutDown";
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
        AC = {
          powerButtonAction = "shutDown";
        };
        lowBattery = {
          powerButtonAction = "shutDown";
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

{
  config,
  pkgs,
  stdenv,
  ...
}:

let
  theme-lain = pkgs.stdenv.mkDerivation {
    pname = "lain";
    version = "ce5c8a0acf48eb116882f04fe731339b0f710927";
    src = pkgs.fetchFromGitHub {
      owner = "dgudim";
      repo = "themes";
      rev = "ce5c8a0acf48eb116882f04fe731339b0f710927";
      hash = "sha256-GVZWWJvaZjO2YvhSIpEVUakkEXnWcfwg3E+1QXHuDeY=";
    };
    installPhase = ''
      mkdir -p $out/share/plasma/look-and-feel
      cp -aR KDE-loginscreens/Lain/ $out/share/plasma/look-and-feel/Lain
    '';
  };
in
{
  fonts.fontconfig.enable = true; # 允许用户自定义字体
  home = {
    username = "mcseekeri";
    homeDirectory = "/home/mcseekeri";
    stateVersion = "24.11";

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
      # 主题
      theme-lain
      # 游戏娱乐
      moonlight-qt
      # 输入法
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
      fcitx5-fluent
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
      workspace = {
        clickItemTo = "select"; # 禁止历史倒车
        cursor.size = 36;
        splashScreen.theme = "Lain"; # I am falling, I am fading, I have lost it all
      };
      kwin = {
        virtualDesktops.number = 2;
        virtualDesktops.rows = 2;
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
        general = {
          family = "Noto Sans";
          pointSize = 13;
        };
        small = {
          family = "Noto Sans";
          pointSize = 11;
        };
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
    kdeconnect.enable = true;
    flameshot.enable = true;
  };
  # TODO: 外观微调，常见软件的预配置
}

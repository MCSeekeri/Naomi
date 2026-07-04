{ pkgs, self, ... }: {
  imports = [
    "${self}/modules/Home/browser/librewolf.nix"
    "${self}/modules/Home/browser/chromium.nix"
    "${self}/modules/Home/fish/tide.nix"
    # "${self}/modules/Home/activitywatch.nix"
    "${self}/modules/Home/awesome-terminal.nix"
    "${self}/modules/Home/direnv.nix"
    "${self}/modules/Home/kitty.nix"
    "${self}/modules/Home/niri"
    "${self}/modules/Home/vscode.nix"
    "${self}/modules/Home/prc.nix"
  ];

  home = {
    username = "mcseekeri";
    homeDirectory = "/home/mcseekeri";
    stateVersion = "26.05";

    packages = with pkgs; [
      # 桌面应用
      keepassxc
      qq
      wpsoffice-cn
      kdePackages.kdenlive
      kdePackages.kleopatra
      kdePackages.kcalc
      anki-bin
      discord
      ayugram-desktop
      qbittorrent-enhanced
      krita
      obsidian
      kiwix
      element-desktop
      remmina
      blender
      piliplus
      # bitwarden-desktop
      peazip
      libreoffice-qt-fresh # 无用户信息泄露，比 WPS 不知道高到哪里去了……
      motrix-next
      # 主题
      lain-kde-splashscreen
      # kora-icon-theme
      # dracula-icon-theme
      plasma-overdose-kde-theme
      # 游戏娱乐
      moonlight-qt
      vlc
      ckan
      r2modman
      musikcube
      lutris
      (bottles.override { removeWarningPopup = true; })
      # 开发套件
      rustup
      gnumake
      musl
      nixpkgs-review
      lucky-commit
      pkg-config
      fvm
      android-studio
      nodejs
      pnpm
      yarn-berry
      unityhub
      imhex
      # micromamba
      gradle
      reqable
      flutter
      # 常用工具
      btrfs-assistant
      nix-diff
      yt-dlp
      ffmpeg-full
      rclone
      httrack
      nixos-anywhere
      cachix
      mat2
      exiftool
      aria2
    ];
    # ++ (lib.pipe kdePackages.sources [
    #   builtins.attrNames
    #   (builtins.map (n: kdePackages.${n}))
    #   (builtins.filter (pkg: !(pkg.meta.broken or false) && !(pkg.meta.insecure or false)))
    #   (builtins.filter (pkg:
    #     !(lib.elem pkg.pname [
    #       "neochat"
    #     ])
    #   ))
    # ]);
    # 安装整个 kdePackages 包组
    # 这个主意比看起来更糟糕……

    sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "32";
    };
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
    };
  };

  services.flatpak.packages = [
    "com.parsecgaming.parsec"
    "com.dingtalk.DingTalk"
    "com.tencent.wemeet"
  ];

  programs = {
    home-manager.enable = true;
    zed-editor = {
      enable = true;
      enableMcpIntegration = true;
    };
    librewolf = {
      profiles = {
        user = {
          settings = {
            "identity.fxaccounts.enabled" = true;
            "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true; # 要留清白在人间……
            "privacy.clearOnShutdown_v2.formdata" = true;
            "places.history.enabled" = false;
          };
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            # https://discourse.nixos.org/t/firefox-extensions-with-home-manager/34108/4
            kiss-translator
            # aw-watcher-web
            private-relay
            bitwarden
            steam-database
          ];
        };
      };
    };
    chromium = {
      package = pkgs.ungoogled-chromium;
      extensions = [
        { id = "fpeoodllldobpkbkabpblcfaogecpndd"; } # Webrecoder
        { id = "pfnededegaaopdmhkdmcofjmoldfiped"; } # ZeroOmega
        { id = "chphlpgkkbolifaimnlloiipkdnihall"; } # OneTab
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        { id = "eaoelafamejbnggahofapllmfhlhajdd"; } # B站空降助手
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
        { id = "mafpmfcccpbjnhfhjnllmmalhifmlcie"; } # ...
        { id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"; } # SteamDB
        { id = "hhinaapppaileiechjoiifaancjggfjm"; } # Web Scrobbler
      ];
    };
    vscodium = {
      profiles.default.extensions = with pkgs.vscode-marketplace; [
        activitywatch.aw-watcher-vscode
        dracula-theme.theme-dracula
        esbenp.prettier-vscode
        pinage404.nix-extension-pack
        usernamehw.errorlens
        vivaxy.vscode-conventional-commits
      ];
    };
    git = {
      settings = {
        user = {
          name = "MCSeekeri";
          email = "mcseekeri@outlook.com";
        };
        signing = {
          key = "3276666666666666!";
          signByDefault = true;
        };
        commit = {
          gpgsign = true;
        };
        tag = {
          gpgsign = true;
        };
      };
    };
    fish = {
      enable = true; # 比 zsh 更好，可惜不兼容 bash
      shellAliases = {
        proxy = "proxychains4 -q";
      };
    };
    mpv = {
      enable = true;

      package = pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          modernz
          evafast
          thumbfast
          mpris
        ];
      };

      config = {
        osc = "no";
        osd-bar = "no";

        vo = "gpu-next";
        profile = "high-quality";

        slang = "zh,chi,zho,en";
        alang = "zh,chi,zho,en";
        sub-auto = "fuzzy";

        keep-open = "yes";
        #osd-bar = "no";
        #border = "no";
        #cursor-autohide = 1000;
      };
    };
    thunderbird = {
      enable = true;
    };
    plasma = {
      enable = true;
      overrideConfig = true;
      input = {
        touchpads = [
          {
            disableWhileTyping = true;
            enable = true;
            middleButtonEmulation = true;
            naturalScroll = true;
            tapToClick = true;
            name = "ELAN0001:00 04F3:327E Touchpad";
            productId = "327e";
            vendorId = "04f3";
          }
        ];
      };
      workspace = {
        colorScheme = "BreezeDark";
        wallpaper = pkgs.fetchurl {
          url = "https://github.com/MCSeekeri/storage/raw/main/wallpaper/ahh_a_snake.jpg";
          sha256 = "1gifgvnp5dr0hzj1nif5448jd4vclppnfw1msvxyicb4m1k1hibm";
        };
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
                  "applications:kitty.desktop"
                  "applications:librewolf.desktop"
                ];
              };
            }
            {
              name = "org.kde.plasma.systemmonitor.cpu";
              config = {
                Appearance.title = "总 CPU 使用率";
                Appearance.chartFace = "org.kde.ksysguard.piechart";
                Sensors = {
                  highPrioritySensorIds = [ "cpu/all/usage" ];
                  totalSensors = [ "cpu/all/usage" ];
                };
                SensorColors."cpu/all/usage" = "89,194,255";
              };
            }
            {
              name = "org.kde.plasma.systemmonitor.memory";
              config = {
                Appearance.title = "内存使用率";
                Appearance.chartFace = "org.kde.ksysguard.piechart";
                Sensors = {
                  highPrioritySensorIds = [ "memory/physical/used" ];
                  totalSensors = [ "memory/physical/usedPercent" ];
                };
                SensorColors."memory/physical/used" = "89,194,255";
              };
            }
            {
              name = "org.kde.plasma.systemmonitor.diskactivity";
              config = {
                Appearance.title = "磁盘活动";
                Appearance.chartFace = "org.kde.ksysguard.textonly";
                Sensors.highPrioritySensorIds = [
                  "disk/all/write"
                  "disk/all/read"
                ];
                SensorColors = {
                  "disk/all/write" = "89,194,255";
                  "disk/all/read" = "255,150,89";
                };
              };
            }
            {
              name = "org.kde.plasma.systemmonitor.net";
              config = {
                Appearance.title = "网络速度";
                Appearance.chartFace = "org.kde.ksysguard.textonly";
                Sensors.highPrioritySensorIds = [
                  "network/all/download"
                  "network/all/upload"
                ];
                SensorColors = {
                  "network/all/download" = "89,194,255";
                  "network/all/upload" = "255,150,89";
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
          height = 68;
        }
      ];
      kwin = {
        virtualDesktops.number = 2;
        virtualDesktops.rows = 2;
      };
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
        };
      };
      kscreenlocker = {
        timeout = 2;
      };
      configFile = {
        kcminputrc."Mouse" = {
          "X11LibInputXAccelProfileFlat" = true;
          "XLbInptPointerAcceleration" = 0.4;
        };
        kdeglobals = {
          "KDE"."AnimationDurationFactor" = 0.25;
          "DialogIcons"."Size" = 48;
          "DirSelect Dialog"."DirSelectDialog Size" = "1292,596";
          "General" = {
            "TerminalApplication" = "kitty";
            "TerminalService" = "kitty.desktop";
          };
          "GeileDialog Settings"."Sort directories first" = true;
          "KFileDialog Settings" = {
            "Sort hidden files last" = false;
            "Sort reversed" = false;
            "View Style" = "DetailTree";
            "Allow Expansion" = true;
            "Show Inline Previews" = false;
            "Show Preview" = true;
            "Show Speedbar" = true;
            "Show hidden files" = true;
            "Sort by" = "Date";
          };
          "KFgins"."baloosearchEnabled" = true;
        };
        kiorc."Confirmations" = {
          "ConfirmDelete" = true;
          "ConfirmEmptyTrash" = true;
        };
        kiorc."Executable scripts"."behaviourOnLaunch" = "execute";
        klipperrc."General" = {
          "IgnoreImages" = false;
          "MaxClipItems" = 150;
        };
        krunnerrc = {
          "PlasmaRunnerManager"."migrated" = true;
          "Pluneral"."XftSubPixel" = "rgb";
        };
        kwinrc."Xwayland" = {
          "Scale" = 1.25;
          "XwaylandEavesdrops" = "Modifiers";
        };
        plasmaparc."General"."RaiseMaximumVolume" = true;
      };
    };
    noctalia.settings = {
      audio = {
        enable_overdrive = true;
        enable_sounds = true;
      };
      bar = {
        order = [ "main" ];
        main = {
          contact_shadow = true;
          end = [
            "tray"
            "notifications"
            "network"
            "bluetooth"
            "input_volume"
            "volume"
            "battery"
            "power_profile"
            "control-center"
            "session"
          ];
          margin_edge = 0;
          margin_ends = 0;
          margin_h = 24;
          margin_v = 12;
          padding = 16;
          radius = 0;
          scale = 2.0;
          shadow = false;
          start = [
            "workspaces"
            "launcher"
            "media"
            "audio_visualizer"
            "cat"
          ];
          thickness = 46;
          center = [
            "clock"
            "weather"
          ];
        };
      };
      brightness.enable_ddcutil = true;
      dock = {
        active_monitor_only = true;
        auto_hide = true;
        enabled = true;
        icon_size = 64;
        launcher_position = "start";
        show_dots = true;
        reserve_space = false;
      };

      nightlight.enabled = true;

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "suspend"
        ];
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 60;
          };
          screen-off = {
            action = "screen_off";
            enabled = true;
            timeout = 65;
          };
          suspend = {
            action = "suspend";
            enabled = false;
            lock_before_suspend = true;
            timeout = 900;
          };
        };
      };

      notification.layer = "overlay";

      shell = {
        font_family = "Sarasa UI SC";
        corner_radius_scale = 1.2;
        clipboard_auto_paste = "off";
        lang = "zh-Hans";
        launch_apps_as_systemd_services = true;
        niri_overview_type_to_launch_enabled = true;
        password_style = "random";
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = true;
        ui_scale = 1.25;
        panel = {
          control_center_placement = "floating";
          launcher_placement = "attached";
          launcher_position = "auto";
          launcher_session_search = true;
          transparency_mode = "soft";
        };
        screen_corners.enabled = true;
        show_location = false;
      };

      backdrop = {
        enabled = true;
      };

      wallpaper = {
        transition_on_startup = true;
      };

      widget = {
        active_window.title_scroll = "always";
        audio_visualizer = {
          capsule = false;
          centered = false;
          mirrored = false;
          bands = 32;
          color_1 = "tertiary";
          color_2 = "error";
        };
        battery = {
          display_mode = "graphic";
          hide_when_full = true;
          hide_when_plugged = true;
          show_label = false;
          warning_threshold = 30;
        };
        bluetooth.hide_when_no_connected_device = true;
        cat = {
          audio_spectrum = true;
          tappy_mode = true;
          type = "noctalia/bongocat:cat";
        };
        clock.format = "{:%x %H:%M}";
        date.format = "{:%F}";
        input_volume.mute_color = "on_surface";
        lock_keys = {
          display = "full";
          show_scroll_lock = true;
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "on_hover";
        };
        network = {
          capsule = false;
          show_label = false;
        };
        notifications.hide_when_no_unread = true;
        power_profiles.capsule = false;
        tray = {
          drawer = true;
          match_adjacent_spacing = true;
        };
        weather.show_condition = false;
        workspaces.minimal = true;
      };
    };
  };
  stylix = {
    enable = true;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/MCSeekeri/storage/raw/main/wallpaper/ahh_a_snake.jpg";
      sha256 = "1gifgvnp5dr0hzj1nif5448jd4vclppnfw1msvxyicb4m1k1hibm";
    }; # https://www.deviantart.com/chasingartwork/art/ahh-a-snake-383715432
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    fonts = {
      sizes = {
        applications = 16;
        desktop = 16;
        popups = 16;
        terminal = 16;
      };
      sansSerif = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa UI SC";
      };
      serif = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa UI SC";
      };
      monospace = {
        package = pkgs.maple-mono.Normal-NF-CN-unhinted;
        name = "Maple Mono Normal NF CN";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      gtk.enable = false;
      kde.enable = false;
    };
  };
}

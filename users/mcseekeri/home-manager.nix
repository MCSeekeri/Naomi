{
  pkgs,
  self,
  config,
  ...
}:
{
  imports = [
    "${self}/modules/Home/browser/librewolf.nix"
    "${self}/modules/Home/browser/chromium.nix"
    "${self}/modules/Home/fcitx5"
    "${self}/modules/Home/fish/tide.nix"
    "${self}/modules/Home/plasma-manager"
    "${self}/modules/Home/activitywatch.nix"
    "${self}/modules/Home/awesome-terminal.nix"
    "${self}/modules/Home/direnv.nix"
    "${self}/modules/Home/git.nix"
    "${self}/modules/Home/kitty.nix"
    "${self}/modules/Home/sops.nix"
    "${self}/modules/Home/vibe-coding.nix"
    "${self}/modules/Home/vscode.nix"
    "${self}/modules/Home/xdg.nix"
  ];

  home = {
    username = "mcseekeri";
    homeDirectory = "/home/mcseekeri";
    stateVersion = "25.05";

    packages = with pkgs; [
      # 桌面应用
      thunderbird-bin
      keepassxc
      qq
      wechat
      wpsoffice-cn
      motrix
      kdePackages.kdenlive
      kdePackages.kleopatra
      kdePackages.kcalc
      anki-bin
      discord
      ayugram-desktop
      qbittorrent
      krita
      obsidian
      kiwix
      element-desktop
      remmina
      blender
      piliplus
      # 主题
      lain-kde-splashscreen
      # kora-icon-theme
      # dracula-icon-theme
      plasma-overdose-kde-theme
      # 游戏娱乐
      moonlight-qt
      vlc
      lutris
      (bottles.override { removeWarningPopup = true; })
      ckan
      r2modman
      musikcube
      # 开发套件
      uv
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
      # micromamba
      gradle
      dupeguru
      reqable
      flutter
      # 终端增强
      mycli
      pgcli
      iredis
      usql
      # 常用工具
      btrfs-assistant
      nix-diff
      yt-dlp
      ffmpeg-full
      peazip
      rclone
      httrack
      nixos-anywhere
      cachix
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
  };

  services.flatpak.packages = [
    "com.parsecgaming.parsec"
    "com.dingtalk.DingTalk"
    "com.tencent.wemeet"
  ];

  programs = {
    home-manager.enable = true;
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
            keepassxc-browser
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
    vscode = {
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-marketplace; [
        activitywatch.aw-watcher-vscode
        alibaba-cloud.tongyi-lingma
        dracula-theme.theme-dracula
        esbenp.prettier-vscode
        pinage404.nix-extension-pack
        usernamehw.errorlens
        vivaxy.vscode-conventional-commits
        github.copilot
        github.copilot-chat
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
    obs-studio = {
      enable = true;
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
            "XftAntialias" = true;
            "XftHintStyle" = "hintfull";
          };
          "GeileDialog Settings"."Sort directories first" = true;
          "KFileDialog Settings" = {
            "Sort hidden files last" = false;
            "Sort reversed" = true;
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
        plasma-localerc = {
          "Formats"."LANG" = "zh_CN.UTF-8";
          "Translations"."LANGUAGE" = "zh_CN";
        };
        plasmaparc."General"."RaiseMaximumVolume" = true;
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
        name = "Maple Mono SC NF";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets.kde.enable = false;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = ",2560x1440@60,auto,1.5";
  };
}

{ pkgs, self, ... }: {
  imports = [
    "${self}/modules/Home/fish/tide.nix"
    "${self}/modules/Home/git.nix"
    "${self}/modules/Home/direnv.nix"
  ];

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      upx
      lazygit
      git-ignore
      gitleaks
      git-secrets
      xh
      magic-wormhole-rs
      sd
      duf
      gh
      trash-cli
      pandoc
      rsclock
      oha
      ipfetch
      genact
      neo-cowsay
      hyperfine
      fuc
      doggo
      gping
    ];

    shellAliases = {
      ls = "eza";
      ll = "eza -lh --no-user --long";
      df = "duf";
      ping = "gping";
      wget = "xh --download";
      dig = "doggo";
    };
  };

  programs = {
    fish = {
      enable = true;
      shellAliases.proxy = "proxychains4 -q";
    };
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    btop = {
      enable = true;
      settings = {
        show_battery = true;
        show_disks = true;
        io_mode = true;
        update_ms = 100;
        theme_background = false;
        check_temp = true;
      };
    };
    eza = {
      enable = true;
      icons = "auto";
      enableFishIntegration = true;
      git = true;

      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--header"
        "--icons=always"
        "--time-style=long-iso"
        "--classify"
        "--hyperlink"
      ];
    };
    fastfetch = {
      enable = true;
      settings.modules = [
        {
          type = "kernel";
          key = "Kernel";
          keyColor = "31";
        }
        {
          type = "packages";
          key = " ├ 󰏖 ";
          keyColor = "31";
        }
        {
          type = "shell";
          key = " ├  ";
          keyColor = "31";
        }
        {
          type = "terminal";
          key = " └  ";
          keyColor = "31";
        }
        "break"
        {
          type = "cpu";
          key = "CPU   ";
          keyColor = "33";
        }
        {
          type = "loadavg";
          key = " ├ 󰓅 ";
          keyColor = "33";
        }
        {
          type = "memory";
          key = " ├  ";
          keyColor = "33";
        }
        {
          type = "swap";
          key = " ├ 󰋊 ";
          keyColor = "33";
        }
        {
          type = "disk";
          key = " └ 󰋊 ({mountpoint})";
          keyColor = "33";
          folders = [ "/data" ];
        }
        "break"
        {
          type = "terminaltheme";
          key = "   Theme    ";
        }
        {
          type = "datetime";
          key = "   Time     ";
        }
      ];
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
      extraPackages = with pkgs; [
        bat
        chafa
        eza
        exiftool
        ffmpegthumbnailer
        file
        glow
        hexyl
        imagemagick
        jq
        mediainfo
        ouch
        p7zip
        poppler-utils
        sqlite
        rich-cli
        unrar
      ];
      settings = {
        mgr.show_hidden = true;
        preview.show_hidden = "yes";
        plugin = {
          prepend_preloaders = [
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/{subrip,postscript,illustrator,dvb.ait,vnd.adobe.illustrator,eps}";
              run = "mediainfo";
            }
            {
              url = "*.{ai,eps,ait}";
              run = "mediainfo";
            }
          ];
          prepend_previewers = [
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/{subrip,postscript,illustrator,dvb.ait,vnd.adobe.illustrator,eps}";
              run = "mediainfo";
            }
            {
              url = "*.{ai,eps,ait}";
              run = "mediainfo";
            }
            {
              url = "*.csv";
              run = "rich-preview";
            }
            {
              url = "*.ipynb";
              run = "rich-preview";
            }
            {
              url = "*.json";
              run = "rich-preview";
            }
            {
              url = "*.md";
              run = "rich-preview";
            }
            {
              url = "*.rst";
              run = "rich-preview";
            }
          ];
        };
      };
      keymap.mgr.prepend_keymap = [
        {
          on = [
            "g"
            "c"
          ];
          run = "plugin vcs-files";
          desc = "显示版本控制变更";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "启动 Lazygit";
        }
      ];
      plugins = {
        git = {
          package = pkgs.yaziPlugins.git;
          setup = true;
          settings.order = 1500;
        };
        inherit (pkgs.yaziPlugins) lazygit;
        inherit (pkgs.yaziPlugins) piper;
        inherit (pkgs.yaziPlugins) rich-preview;
        inherit (pkgs.yaziPlugins) vcs-files;
        inherit (pkgs.yaziPlugins) zoom;
        inherit (pkgs.yaziPlugins) sudo;
        inherit (pkgs.yaziPlugins) mount;
        inherit (pkgs.yaziPlugins) ouch;
        inherit (pkgs.yaziPlugins) mediainfo;
      };
    };
  };
}

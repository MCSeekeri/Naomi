{ pkgs, self, ... }: {
  imports = [
    "${self}/modules/Home/git.nix"
    "${self}/modules/Home/direnv.nix"
    "${self}/modules/Home/cli-tools.nix"
  ];

  home = {
    stateVersion = "24.05";
  };

  programs = {
    fish = {
      enable = true;
      shellAliases.proxy = "proxychains4 -q";
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

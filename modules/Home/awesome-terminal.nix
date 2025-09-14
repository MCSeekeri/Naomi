{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      kitty
      upx
      lazygit
      delta # git diff
      git-ignore
      gitleaks # 查找文件或仓库中的敏感信息
      git-secrets
      xh # curl
      # noti # fish done
      magic-wormhole-rs
      sd
      duf # df -h
      gh
      trash-cli
      pandoc
      chafa
      rsclock
      cava
      oha # 反向测速
      hollywood
      ipfetch
      genact
      neo-cowsay
      hyperfine
    ];
    shellAliases = {
      ls = "eza";
      ll = "eza  -lh --no-user --long";
    };
  };
  programs = {
    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };
    btop = {
      enable = true;
      package = pkgs.btop.override {
        rocmSupport = true;
        cudaSupport = true;
      };
      settings = {
        show_battery = true;
        show_disks = true;
        io_mode = true;
        update_ms = 100;
        theme_background = false; # 可能看不出来，但这是透明……
      };
    };
    eza = {
      enable = true;
      icons = "auto";
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      git = true;

      extraOptions = [
        "--group-directories-first"
        "--no-quotes" # 不使用符号包裹空格
        "--header"
        "--icons=always"
        "--time-style=long-iso" # YYYY-MM-DD HH:MM 最美妙的表示时间的方式
        "--classify"
        "--hyperlink"
      ];
    };
    # starship = {
    #   enable = true;
    #   enableBashIntegration = true;
    #   enableFishIntegration = true;
    #   enableZshIntegration = true;
    #   enableTransience = true;
    # };
    fastfetch = {
      enable = true;
      # 我完全看不出来有何意义，但 unixporn 上全是这种东西……
      # [TODO] 之后完善更详细的配置
      settings = {
        modules = [
          {
            type = "os";
            key = "OS";
            keyColor = "31";
          }
          {
            type = "kernel";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "packages";
            key = " ├ 󰏖 ";
            keyColor = "31";
          }
          {
            type = "shell";
            key = " └  ";
            keyColor = "31";
          }
          "break"
          {
            type = "wm";
            key = "WM   ";
            keyColor = "32";
          }
          {
            type = "wmtheme";
            key = " ├ 󰉼 ";
            keyColor = "32";
          }
          {
            type = "icons";
            key = " ├ 󰀻 ";
            keyColor = "32";
          }
          {
            type = "cursor";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminal";
            key = " └  ";
            keyColor = "32";
          }
          "break"
          {
            type = "host";
            format = "{5} {1} Type {2}";
            key = "PC   ";
            keyColor = "33";
          }
          {
            type = "cpu";
            format = "{1} ({3}) @ {7} GHz";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "gpu";
            format = "{1} {2} @ {12} GHz";
            key = " ├ 󰢮 ";
            keyColor = "33";
          }
          {
            type = "memory";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "disk";
            key = " ├ 󰋊 ";
            keyColor = "33";
          }
          {
            type = "monitor";
            key = " └  ";
            keyColor = "33";
          }
          "break"
          {
            type = "uptime";
            key = "   Uptime   ";
          }
        ];
      };
    };
  };
}

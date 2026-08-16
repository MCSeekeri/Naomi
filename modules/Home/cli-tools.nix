{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      upx
      lazygit
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
      rsclock
      oha # 反向测速
      ipfetch
      genact
      neo-cowsay
      hyperfine
      fuc # cpz rmz
      doggo # dig
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
        theme_background = false; # 可能看不出来，但这是透明……
        check_temp = true;
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
  };
}

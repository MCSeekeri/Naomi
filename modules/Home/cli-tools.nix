{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      upx
      lazygit
      git-ignore
      gitleaks # 查找文件或仓库中的敏感信息
      curlie
      # noti # fish done
      magic-wormhole-rs
      sd
      ugrep
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
      yq-go
      just
      watchexec
    ];
    shellAliases = {
      ll = "eza -lh --no-user";
      grep = "ugrep";
      df = "duf";
      ping = "gping";
      dig = "doggo";
      curl = "curlie";
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
      git = true;

      extraOptions = [
        "--group-directories-first"
        "--no-quotes" # 不使用符号包裹空格
        "--header"
        "--time-style=long-iso" # YYYY-MM-DD HH:MM 最美妙的表示时间的方式
        "--classify"
        "--hyperlink"
      ];
    };
  };
}

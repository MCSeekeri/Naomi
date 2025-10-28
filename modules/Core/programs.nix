{ pkgs, ... }:
{
  services = {
    sysstat.enable = true;
    gvfs.enable = true;
    pcscd.enable = true;
  };
  programs = {
    proxychains = {
      enable = true;
      package = pkgs.proxychains-ng;
      quietMode = true;
      proxies = {
        geph = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 14514;
        };
      };
    };
    nh = {
      enable = true;
      # clean.enable = true; # 和 nix.gc 不共存
    };
    fish = {
      enable = true; # 比 zsh 更好，可惜不兼容 bash
      useBabelfish = true; # 啥
      shellAliases = {
        proxy = "proxychains4 -q";
      };
    };
    java = {
      enable = true;
      binfmt = true;
      package = pkgs.zulu.override { enableJavaFX = true; };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      package = pkgs.gitFull;
      lfs.enable = true;
    };
    tmux = {
      enable = true;
      clock24 = true; # 显而易见
      aggressiveResize = true;
    };
    yazi = {
      enable = true;
      settings = {
        yazi = {
          mgr.show_hidden = true;
          preview.show_hidden = "yes";
        };
      };
      plugins = {
        inherit (pkgs.yaziPlugins) git;
        inherit (pkgs.yaziPlugins) sudo;
        inherit (pkgs.yaziPlugins) ouch;
        inherit (pkgs.yaziPlugins) mount;
        inherit (pkgs.yaziPlugins) duckdb;
        inherit (pkgs.yaziPlugins) mediainfo;
      };
    };
    zoxide = {
      enable = true;
      flags = [ "--cmd cd" ];
    };
    gnupg.agent = {
      enable = true;
      enableExtraSocket = true;
    };
    openvpn3.enable = true;
    bat.enable = true; # cat
    screen.enable = true;
    nix-index.enable = true;
    command-not-found.enable = false;
    iotop.enable = true;
    iftop.enable = true;
    mtr.enable = true; # traceroute
    bandwhich.enable = true;
  };
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      # 基础必备
      curl
      wget
      tree
      file
      which
      gnused
      gawk
      ripgrep
      jq
      progress
      hexyl
      sbctl
      mosh
      zenity
      # inetutils
      busybox
      # 解压缩
      ouch # 一站式压缩解决方案
      unzip
      zip
      xz
      zstd
      p7zip
      gnutar
      unrar
      # 加解密
      gnupg
      age
      sops
      # 文件系统
      sshfs
      btrfs-progs
      ntfs3g
      compsize
      # Nix 相关
      nixfmt-rfc-style
      nix-update
      nix-du
      graphviz # nix-du -s=500MB | dot -Tsvg > store.svg
      nix-tree
      colmena
      # 终端优化
      babelfish
      speedtest-cli
      killall
      fishPlugins.tide
      fishPlugins.done
      fishPlugins.autopair
      fishPlugins.nvm
      bat
      fd
      yazi
      zellij # tmux
      gping # ping
      tlrc # tldr
      # 网络工具
      nmap
      socat
      libressl
      dnsutils
      # 系统维护
      lm_sensors
      ethtool
      pciutils
      usbutils
      strace
      ltrace
      lsof
      btop
      conntrack-tools
      ncdu
    ];
  };
}

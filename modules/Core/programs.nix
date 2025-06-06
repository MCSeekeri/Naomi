{ pkgs, inputs, ... }:
{
  programs = {
    proxychains.proxies = {
      geph5 = {
        type = "socks5";
        host = "127.0.0.1";
        port = 14514;
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
        conda = "micromamba";
        proxy = "proxychains4 -q";
      };
    };
    java = {
      enable = true;
      binfmt = true;
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
    nix-ld.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
  environment = {
    systemPackages = with pkgs; [
      # 基础必备
      vim
      curl
      wget
      git
      tree
      file
      screen
      tmux
      which
      gnused
      gawk
      screen
      ripgrep
      jq
      progress
      hexyl
      # 解压缩
      ouch # 一站式压缩解决方案
      unzip
      zip
      xz
      zstd
      p7zip
      gnutar
      # 加解密
      gnupg
      age
      sops
      # 文件系统
      sshfs
      btrfs-progs
      ntfs3g
      # Nix 相关
      nixfmt-rfc-style
      inputs.nix-alien.packages.${system}.nix-alien
      inputs.home-manager.packages.${pkgs.system}.default
      nix-update
      nix-du
      graphviz # nix-du -s=500MB | dot -Tsvg > store.svg
      nix-tree
      # 终端优化
      babelfish
      bash-completion
      speedtest-cli
      killall
      fishPlugins.tide
      fishPlugins.done
      fishPlugins.autopair
      bat
      fd
      yazi
      zellij # tmux
      zoxide # cd
      gping # ping
      # 网络工具
      nmap
      socat
      openvpn
      openssl
      dnsutils
      # 系统维护
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils
      strace
      ltrace
      lsof
      btop
      iotop
      iftop
      conntrack-tools
      quota
    ];
  };
}

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
      # 解压缩
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
      nix-visualize
      nix-output-monitor
      nixfmt-rfc-style
      inputs.nix-alien.packages.${system}.nix-alien
      inputs.home-manager.packages.${pkgs.system}.default
      nix-update
      hydra
      vulnix
      nix-du
      nix-tree
      # 终端优化
      babelfish
      bash-completion
      meslo-lgs-nf
      speedtest-cli
      killall
      fishPlugins.tide
      fishPlugins.done
      fishPlugins.autopair
      # 网络工具
      nmap
      socat
      openvpn
      geph.cli
      openssl
      dnsutils
      mariadb.client # 仅安装客户端，而非整个数据库
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
      quickemu
    ];
  };
}

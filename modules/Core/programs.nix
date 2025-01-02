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
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
      shellAliases = {
        conda = "micromamba";
        proxy = "proxychains4 -q";
      };
    };
    java = {
      enable = true;
      binfmt = true;
    };
  };
  environment = {
    variables.EDITOR = "vim";
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
      unzip
      zip
      xz
      zstd
      p7zip
      btrfs-progs
      which
      gnused
      gnutar
      gawk
      gnupg
      age
      sops
      screen
      ripgrep
      jq
      openssl
      ntfs3g
      dnsutils
      sshfs
      # Nix 相关
      nix-visualize
      nix-output-monitor
      nixfmt-rfc-style
      inputs.nix-alien.packages.${system}.nix-alien
      inputs.home-manager.packages.${pkgs.system}.default
      nix-update
      # 终端优化
      bash-completion
      meslo-lgs-nf
      speedtest-cli
      killall
      # 网络属实不怎么安全
      nmap
      socat
      openvpn
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
    ];
  };
}

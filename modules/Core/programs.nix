{
  config,
  lib,
  pkgs,
  ...
}:
{
  services = {
    sysstat.enable = true;
    # gvfs.enable = true;
  };
  programs = {
    proxychains = {
      enable = lib.mkDefault true;
      package = pkgs.proxychains-ng;
      quietMode = true;
      proxies = {
        geph = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 9909;
        };
        clash = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 7890;
        };
      };
    };
    nh = {
      enable = lib.mkDefault true;
      # clean.enable = true; # 和 nix.gc 不共存
    };
    fish = {
      enable = lib.mkDefault true; # 比 zsh 更好，可惜不兼容 bash
      useBabelfish = lib.mkDefault true; # 啥
      shellAliases = lib.mkDefault { proxy = "proxychains4 -q"; };
    };
    neovim = {
      enable = lib.mkDefault true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = lib.mkDefault true;
      package = if config.services.xserver.enable or false then pkgs.gitFull else pkgs.git;
      lfs.enable = true;
    };
    tmux = {
      enable = lib.mkDefault true;
      clock24 = true; # 显而易见
      aggressiveResize = true;
    };
    zoxide = {
      enable = lib.mkDefault true;
      flags = [ "--cmd cd" ];
    };
    gnupg.agent = {
      enable = true;
      enableExtraSocket = true;
    };
    bat.enable = lib.mkDefault true; # cat
    screen.enable = lib.mkDefault true;
    command-not-found.enable = lib.mkDefault false;
    iotop.enable = lib.mkDefault true;
    iftop.enable = lib.mkDefault true;
    mtr.enable = lib.mkDefault true; # traceroute
    bandwhich.enable = lib.mkDefault true;
    mosh = {
      enable = lib.mkDefault true;
      openFirewall = false;
    };
  };
  environment = {
    enableAllTerminfo = true;
    localBinInPath = lib.mkDefault true;
    systemPackages =
      with pkgs;
      [
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
        # Nix 相关
        nix-tree
        # 终端优化
        killall
        fd
        zellij # tmux
        gping # ping
        fastfetch
        # 系统维护
        pciutils
        usbutils
        strace
        ltrace
        lsof
        btop
        ncdu
      ]
      ++ lib.optionals config.networking.networkmanager.enable [
        nmap
        socat
        dnsutils
        nethogs
        iproute2
        conntrack-tools
      ]
      ++ lib.optionals config.programs.fish.enable [
        babelfish
        fishPlugins.autopair
        fishPlugins.done
        fishPlugins.tide
        fishPlugins.puffer
        fishPlugins.git-abbr
        fishPlugins.fish-you-should-use
      ]
      ++
        lib.optionals
          (builtins.any (name: (config.fileSystems.${name}.fsType or "") == "btrfs") (
            builtins.attrNames config.fileSystems
          ))
          [
            btrfs-progs
            compsize
          ]
      ++
        lib.optionals (config.services.xserver.enable or false || config.programs.hyprland.enable or false)
          [
            # 桌面应用
            ungoogled-chromium
            # 开发环境
            gcc
            cmake
            kdePackages.kate
            vscodium-fhs
            go
            python3
            python3Packages.pip
            pipx
            # 虚拟化
            distrobox
            distrobox-tui
            # 系统维护
            kdePackages.partitionmanager
            kdePackages.ksystemlog
            kdePackages.filelight
          ]
      ++ lib.optionals config.virtualisation.podman.enable [
        podman-tui
        lazydocker
        podman-compose
      ];
  };

  nixpkgs = lib.mkIf (
    config.services.xserver.enable or false || config.programs.hyprland.enable or false
  ) { config.chromium.enableWideVine = true; };
}

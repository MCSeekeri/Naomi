# 如果不知道某个设置项的用途，那么在搞明白之前不要动
# 手册参见
# https://nixos.org/manual/nixos/stable/
# 软件和配置查询参见
# https://search.nixos.org/packages?channel=24.11
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # 导入其他配置项
    ./hardware-configuration.nix
    #./hardened.nix
  ];

  # 设置软件源
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d"; # 删除超过一周的垃圾文件，硬盘笑传之踩踩 Backup
    };
    settings = {
      # auto-optimise-store = true; # 会让 build 变慢，见仁见智吧
      substituters = lib.mkForce [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirror.nju.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      # 启动 Flake，勿动，除非你知道你在做什么
      # https://nixos.wiki/wiki/Flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "mcseekeri"
        "root"
      ];
    };
  };
  # 允许非自由软件
  nixpkgs.config = {
    allowUnfree = true;
  };

  # 系统版本号，只在更新时修改
  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
    # autoUpgrade.allowReboot = true; 升级后如果有内核级更新就自动重启，和自动更新同时打开会有惊喜
  };

  #################### 基础系统配置 ####################

  # 靴子载入器
  boot = {
    # kernelPackages = linuxKernel.packages.linux_zen; # Zen 内核，似乎不太适合工作站
    loader = {
      # efi.canTouchEfiVariables = false;
      # 在部分 EFI 分区不可修改的设备上需要这个选项
      efi.efiSysMountPoint = "/boot/EFI";
      systemd-boot = {
        enable = true;
        editor = false;
        # 启动的时候最多显示 20 个版本
        # 如果跑了 20 个配置文件还没修好 Bug，我建议你反思下
        configurationLimit = 20;
      };
    };
  };

  hardware = {
    # nvidia.open = true; # bruh
    # nvidia.nvidiaPersistenced = true; # brruh
    # nvidia-container-toolkit.enable = true; # brrruh
    # nvidia.datacenter.enable = true; # brrrrr……哦不对，上面没批 NVLink
    xpadneo.enable = true; # 微软手柄蓝牙驱动，我猜上班是用来摸鱼的。
  };

  # 网络配置
  networking = {
    hostName = "Naomi"; # 主机名，设置好之后最好不要修改
    networkmanager.enable = true;
    # interfaces = {
    # eno2.ipv4.addresses = [{
    #  address = ""; # 丢到机房之前再设置，现在不需要
    #  prefixLength = 24;
    # }];
    # };
    # defaultGateway = "";
    # nameservers = ["" ""];
  };

  # 必要的时候在这里配置代理
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Asia/Shanghai";
  time.hardwareClockInLocalTime = false; # 设置硬件时间为 UTC
  networking.timeServers = [
    "cn.ntp.org.cn"
    "ntp.aliyun.com"
    "ntp1.aliyun.com"
    "ntp2.aliyun.com"
    "ntp3.aliyun.com"
    "ntp4.aliyun.com"
    "ntp.tuna.tsinghua.edu.cn"
  ];

  # 安全防护
  networking = {
    firewall = {
      allowedTCPPorts = [
        22
        80
        443
        3389
      ];
      allowedUDPPorts = [
        80
        443
        7844
      ]; # 防火墙放行端口设置
      allowedTCPPortRanges = [
        # 预留给开发环境
        # 只是提醒一下……如果写了 10000-20000，那么 nix 会真的进行计算，得出 -10000 然后报错
        # 真是聪明的有点傻
        {
          from = 10000;
          to = 20000;
        }
      ];
    };
  };

  #################### 用户设置 ####################

  # 定义用户，记得用 passwd 设置密码
  # 使用 useradd 添加的用户重启后会消失
  users = {
    motdFile = "/etc/motd";
    users.mcseekeri = {
      isNormalUser = true;
      #description = "";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "podman"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
      ];
    };
  };

  #################### 安全加固 ####################
  boot = {
    kernelParams = [
      # 从网上抄的，能用就不动
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "pti=on"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "lockdown=confidentiality"
      "quiet"
      "loglevel=0"
      "spectre_v2=on"
      "spec_store_bypass_disable=on"
      "tsx=off"
      "tsx_async_abort=full,nosmt"
      "mds=full,nosmt"
      "l1tf=full,force"
      "nosmt=force"
      "kvm.nx_huge_pages=force"
      "intel_iommu=on"
      "efi=disable_early_pci_dma"
    ];
    blacklistedKernelModules = [
      # 一些几百年没人用的协议
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n-hdlc"
      "x25"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"
      "vivid"
    ];
    kernel.sysctl = {
      # 网络
      "net.core.rmem_max" = 12582912; # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
      "net.core.wmem_max" = 8388608;
      "net.ipv4.icmp_echo_ignore_all" = 1; # 禁止ping
      "net.ipv4.tcp_syncookies" = 1; # 反 SYN 攻击
      "net.ipv4.tcp_rfc1337" = 1; # https://datatracker.ietf.org/doc/html/rfc1337
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0; # 禁用源路由，避免中间人攻击
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.default.accept_ra" = 0; # 禁用 IPv6 路由器通告
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0; # 禁用 TCP SACK https://tools.ietf.org/html/rfc2018
      "net.ipv4.tcp_timestamps" = 0; # 禁用 IPv4 时间戳
      # 内核
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1; # 创建符号链接会验证所有者
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2; # 防止在全局可写的目录里创建文件
      "vm.max_map_count" = 1048576;
      "fs.suid_dumpable" = 0; # 从 sysctl 禁用出错内存转储
      "vm.swappiness" = 1; # 仅在绝对必要的时候使用虚拟内存
    };
  };
  security = {
    sudo-rs.enable = true; # 锈批！
    sudo-rs.execWheelOnly = true;
    # sudo.execWheelOnly = true; # 只允许 wheel 组执行 sudo
    chromiumSuidSandbox.enable = true; # Chrome 沙盒化
    forcePageTableIsolation = true; # 页表隔离，完全避免熔断漏洞
  };

  #################### 软件和服务 ####################

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings.PermitRootLogin = "no"; # 禁止 root 远程登录
      banner = "UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED\n禁止未经授权访问本设备\n\nYou must have explicit, authorized permission to access or configure this device. Unauthorized attempts and actions to access or use this system may result in civil and/or criminal penalties. All activities performed on this device are logged and monitored.\n您必须具有明确的授权权限才能访问或配置此设备。未经授权尝试访问或使用本系统可能会导致民事和/或刑事处罚。在此设备上执行的所有活动都会被记录和监控。\n\n";
    }; # 从 Reddit 抄的，好玩
    fail2ban = {
      enable = true;
      ignoreIP = [
        "127.0.0.1"
        "192.168.0.0/16"
        "100.64.0.0/10" # tailscale 豁免
      ];
      maxretry = 5; # 我总是搞错密码
    };
    xserver = {
      enable = true;
      # videoDrivers = [  "nvidia" "modesetting" "fbdev"];
    };
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true; # 开启 flatpak 支持，有效解决 nixOS 桌面软件水土不服的问题

    # printing.enable = true; # 周二 OpenOffice 不许打印

    # xrdp = {
    #   enable = true;
    #   openFirewall = true;
    #   defaultWindowManager = "startplasma-wayland";
    # };
    # 给 Windows 用户准备的，唉，兼容性
    clamav = {
      updater = {
        enable = true;
      };
      daemon = {
        enable = true;
        settings = {
          MaxThreads = 16;
          MaxDirectoryRecursion = 65535;
          VirusEvent = "echo 'Virus Detected' >> /etc/motd";
        };
      };
    };
    tailscale = {
      enable = true;
      extraUpFlags = [ "--accept-routes --advertise-exit-node" ];
      openFirewall = true;
    };
    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  i18n = {
    # 默认语言不要设置为中文，tty 下会出大悲剧
    defaultLocale = "en_US.UTF-8";
    # 设置 fcitx5 为默认输入方案
    inputMethod = {
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-chinese-addons
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          fcitx5-fluent
        ];
      };
    };
  };

  qt.platformTheme = "kde";
  # 字体这里还有很大的问题，之后慢慢修复
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true; # 自动安装基本字体
    enableGhostscriptFonts = true; # 啥
    fontconfig = {
      useEmbeddedBitmaps = true; # 啥
      cache32Bit = true;
      defaultFonts.serif = [ "Noto Serif" ];
      defaultFonts.sansSerif = [ "Noto Sans CJK" ];
      defaultFonts.monospace = [ "Noto Sans Mono" ];
    };
    packages = with pkgs; [
      wqy_zenhei
      wqy_microhei
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      sarasa-gothic
      fira-code
      cascadia-code
      unifont
      # 诸如微软雅黑或者苹方什么的……为了避免版权炮，自行添加到
      # $HOME/.local/share/fonts
    ];
  };

  # 各类软件的自定义配置
  # 优先 Nix,搞不定再去琢磨 dotfiles.
  programs = {
    partition-manager.enable = true;
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
    xwayland.enable = true;
    steam = {
      # enable = true; # 编译大爆炸，之后再说
      extest.enable = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      remotePlay.openFirewall = true;
    };
    obs-studio = {
      enableVirtualCamera = true;
    };
  };

  # 安装的软件包
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
      microcodeIntel
      ntfs3g
      dnsutils
      # Nix 相关
      nix-visualize
      nix-output-monitor
      nixfmt-rfc-style
      # 安全防护
      fail2ban
      firewalld-gui
      firewalld
      clamav
      # 输入法
      fcitx5
      fcitx5-configtool
      # 终端优化
      bash-completion
      meslo-lgs-nf
      speedtest-cli
      killall
      # 桌面应用
      ungoogled-chromium
      xdg-desktop-portal
      xdg-dbus-proxy
      kdePackages.xdg-desktop-portal-kde
      # 开发环境
      gcc
      cmake
      kdePackages.kate
      vscodium-fhs
      nodejs_22
      go
      jdk21
      maven
      python311
      python311Packages.pip
      pipx
      git-repo
      # 虚拟化
      distrobox
      distrobox-tui
      podman-tui
      podman-compose
      podman-desktop
      # 网络属实不怎么安全
      nmap
      metasploit
      wireshark
      socat
      openvpn
      netcat-openbsd
      # 系统维护
      kdePackages.ksystemlog
      kdePackages.filelight
      btrfs-snap
      snapper
      snapper-gui
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
      cloudflared
      bubblewrap
      virt-manager
      conntrack-tools
      # 专业救场
      remmina
      # Just For Fun!
      hollywood
      fastfetch
      ipfetch
      genact
      neo-cowsay
    ];
  };

  systemd = {
    coredump = {
      enable = false;
      extraConfig = "Storage=none"; # 从 systemd 禁用出错内存转储
    };
    # 我之后再写好这个
    # services = {
    #   warp-svc = {
    #     wantedBy = [ "multi-user.target" ];
    #     after = [ "network.target" ];
    #     description = "Cloudflare WRAP Service";
    #     serviceConfig = {
    #       ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
    #       Restart = "on-failure";
    #     };
    #   };
    # };
  };

  # 虚拟化设置
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true; # 不知道为什么这年头所有人都在讲 TPM
    };
    # waydroid.enable = true; # 弗如原神
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true; # 用户体验不变
      networkSocket.openFirewall = true;
    };
  };
}

{ pkgs, ...}:{  # 安装的软件包
  environment = {
    variables.EDITOR = "vim";
    systemPackages = with pkgs; [
      # Nix 相关
      inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
      inputs.nix-software-center.packages.${system}.nix-software-center
      # 输入法
      fcitx5
      fcitx5-configtool
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
      metasploit
      wireshark
      netcat-openbsd
      # 系统维护
      kdePackages.partitionmanager
      kdePackages.ksystemlog
      kdePackages.filelight
      btrfs-snap
      snapper
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
}
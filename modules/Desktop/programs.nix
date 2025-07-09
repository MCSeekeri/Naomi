{ pkgs, ... }:
{
  # 安装的软件包
  environment = {
    systemPackages = with pkgs; [
      # Nix 相关
      nixos-generators
      # 桌面应用
      ungoogled-chromium
      brave
      # 开发环境
      gcc
      cmake
      kdePackages.kate
      vscodium-fhs
      nodejs_22
      go
      jdk
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
      # podman-desktop # Electron 34 EOL
      # 系统维护
      kdePackages.partitionmanager
      kdePackages.ksystemlog
      kdePackages.filelight
      cloudflared
      bubblewrap
      conntrack-tools
      # 专业救场
      remmina
      wineWowPackages.stable
      winetricks
      # Just For Fun!
      hollywood
      fastfetch
      ipfetch
      genact
      neo-cowsay
    ];
  };
  nixpkgs.config.chromium.enableWideVine = true;
}

{ pkgs, ... }:
{
  # 安装的软件包
  environment = {
    systemPackages = with pkgs; [
      # 桌面应用
      ungoogled-chromium
      wineWowPackages.stable
      winetricks
      # 开发环境
      gcc
      cmake
      kdePackages.kate
      vscodium-fhs
      go
      jdk
      python3Full
      python3Packages.pip
      pipx
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
    ];
  };
  nixpkgs.config.chromium.enableWideVine = true;
}

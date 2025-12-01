{ pkgs, ... }:
{
  # 安装的软件包
  environment = {
    systemPackages = with pkgs; [
      # 桌面应用
      ungoogled-chromium
      # 开发环境
      gcc
      cmake
      kdePackages.kate
      vscodium-fhs
      go
      jdk
      python3
      python3Packages.pip
      pipx
      # 虚拟化
      distrobox
      distrobox-tui
      podman-tui
      lazydocker
      podman-compose
      # 系统维护
      kdePackages.partitionmanager
      kdePackages.ksystemlog
      kdePackages.filelight
    ];
  };
  nixpkgs.config.chromium.enableWideVine = true;
}

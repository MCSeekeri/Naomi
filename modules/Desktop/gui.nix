{ pkgs, ... }:
{
  services = {
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
  };
  xdg.portal.enable = true;
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
}
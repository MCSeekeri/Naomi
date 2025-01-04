{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true; # 自动安装基本字体
    enableGhostscriptFonts = true; # 啥
    fontconfig = {
      useEmbeddedBitmaps = true; # 啥
      cache32Bit = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK" ];
        monospace = [ "Noto Sans Mono" ];
      };
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

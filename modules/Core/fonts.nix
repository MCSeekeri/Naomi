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
        serif = [
          "Source Han Serif SC"
          "Source Han Serif TC"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Source Han Sans SC"
          "Source Han Sans TC"
          "Noto Color Emoji"
        ];
        monospace = [ "Maple Mono Normal NF CN" ];
      };
    };
    packages = with pkgs; [
      wqy_zenhei
      wqy_microhei
      source-sans
      source-serif
      source-han-sans
      source-han-serif
      noto-fonts-emoji
      maple-mono-SC-NF
      # TODO)) 等 7.x 的 Maple Mono 发布之后还得重写所有的字体配置
      # maple-mono.Normal-NF-CN-unhinted
      unifont

      # 诸如微软雅黑或者苹方什么的……为了避免版权炮，自行添加到
      # $HOME/.local/share/fonts
    ];
  };
}

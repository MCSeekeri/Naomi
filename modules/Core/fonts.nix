{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true; # 自动安装基本字体
    fontconfig = {
      useEmbeddedBitmaps = true; # 啥
      cache32Bit = true;
      hinting.enable = false;
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
      noto-fonts-color-emoji
      maple-mono.Normal-NF-CN-unhinted
      unifont

      # 此处仅提供了最基础的中英文字体和必要的兜底字体
      # 如果需要更多常用字体，请参考 modules/Desktop/extra-fonts.nix
    ];
  };
}

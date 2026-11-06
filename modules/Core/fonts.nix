{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = false;
    # 没人需要 unifont 和 FreeFont……
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
    ];
    fontconfig = {
      cache32Bit = true;
      hinting.enable = false;
    };
  };
}

{ pkgs, ... }: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      useEmbeddedBitmaps = true;
      cache32Bit = true;
      hinting.enable = false;
    };
    packages = with pkgs; [
      wqy_zenhei
      wqy_microhei
      unifont
    ];
  };
}

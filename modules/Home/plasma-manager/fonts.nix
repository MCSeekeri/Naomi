let
  defaultFont = {
    family = "Sarasa UI SC";
    pointSize = 13;
  };
in
{
  programs = {
    plasma = {
      fonts = {
        # 重复设置太多，抽象一下
        general = defaultFont;
        fixedWidth = {
          inherit (defaultFont) pointSize;
          family = "Sarasa Mono SC";
        };
        small = {
          inherit (defaultFont) family;
          pointSize = 11;
        };
        toolbar = defaultFont;
        menu = defaultFont;
        windowTitle = defaultFont;
      };
    };
  };
}

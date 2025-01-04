{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Source Code Pro";
        package = pkgs.source-code-pro;
      }
    ];
    extraConfig = "font-size=16";
    hwRender = true;
  };
}

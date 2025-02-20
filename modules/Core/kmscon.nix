{ pkgs, ... }:
{
  console = {
    earlySetup = true;
    packages = [ pkgs.kmscon ];
  };

  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Sarasa Term SC";
        package = pkgs.sarasa-gothic;
      }
    ];
    extraConfig = "font-size=16";
    hwRender = true;
  };
}

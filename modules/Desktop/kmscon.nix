{ pkgs, lib, ... }: {
  console = {
    earlySetup = true;
    packages = [ pkgs.kmscon ];
  };

  services.kmscon = {
    enable = true;
    config = lib.mkDefault {
      font-name = "Maple Mono Normal CN";
      font-size = 16;
    };
    hwRender = true;
  };
}

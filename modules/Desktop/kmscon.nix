{ lib, ... }: {
  console = {
    earlySetup = true;
  };

  services.kmscon = {
    enable = true;
    config = lib.mkDefault {
      font-name = "Maple Mono Normal NF CN";
      font-size = 16;
      hwaccel = true;
    };
  };
}

{ lib, ... }: {
  services.caddy = {
    enable = true;
    globalConfig = lib.mkBefore ''
      grace_period 10s
    '';
  };
}

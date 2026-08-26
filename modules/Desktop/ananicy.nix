{ lib, pkgs, ... }: {
  services.ananicy = {
    enable = lib.mkDefault true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };
}

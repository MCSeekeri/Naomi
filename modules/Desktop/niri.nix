{
  pkgs,
  self,
  lib,
  ...
}:
{
  imports = [ "${self}/modules/Desktop/gui.nix" ];

  programs = {
    niri.enable = true;
    xwayland.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [ xwayland-satellite ];
}

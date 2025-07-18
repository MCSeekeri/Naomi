{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Desktop/adb.nix" ];

  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
    waydroid-helper
  ];
}

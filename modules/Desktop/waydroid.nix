{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Desktop/adb.nix" ];

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    waydroid-helper
  ];
}

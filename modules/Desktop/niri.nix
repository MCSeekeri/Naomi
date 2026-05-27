{ pkgs, ... }:
{
  programs = {
    niri = {
      enable = true;
    };
    xwayland.enable = true;
  };

  security.pam.services = {
    login.enableGnomeKeyring = true;
    passwd.enableGnomeKeyring = true;
    sddm.enableGnomeKeyring = true;
  };

  xdg.portal = {
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    kitty
    nautilus
    pavucontrol
    playerctl
    xwayland-satellite
  ];
}

{ pkgs, ... }: {
  programs = {
    niri = {
      enable = true;
    };
    dconf.enable = true;
    xwayland.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
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
    gnome-calculator
    gnome-characters
    gnome-disk-utility
    gnome-font-viewer
    gnome-logs
    gnome-system-monitor
    gnome-text-editor
    kitty
    loupe
    nemo
    nemo-fileroller
    nemo-preview
    nemo-seahorse
    pavucontrol
    playerctl
    seahorse
    xwayland-satellite
    ddcutil
  ];
}

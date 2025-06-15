{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Desktop/gui.nix" ];
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true; # 我们还生活在 20 世纪，至少一部分是。
    };
    hyprlock.enable = true;
    uwsm.enable = true;
    nm-applet.enable = true; # GNOME 网络面板
  };

  services.hypridle.enable = true;
  security.pam.services.hyprlock = { };
  fonts.packages = with pkgs; [ font-awesome ];

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
    systemPackages = with pkgs; [
      # 文件管理
      nautilus
      # 终端
      kitty
      foot
      # 必备功能
      walker
      hyprpaper
      brightnessctl
      playerctl
      networkmanagerapplet
      pavucontrol
      inxi
      waybar
      nwg-look
      hyprshot
      wl-clip-persist
      # 鼠标指针
      hyprcursor
      rose-pine-hyprcursor
    ];
  };

  xdg.portal = {
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}

{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [ "${self}/modules/Desktop/gui.nix" ];
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = lib.mkDefault true; # 以备解耦
      wayland.enable = lib.mkDefault true;
    };
  };
  programs.xwayland.enable = true;
  xdg.portal = {
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
    config.common.default = lib.mkDefault "kde";
  };
  environment.systemPackages = [
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default # Wayland
  ];
}

{
  pkgs,
  lib,
  self,
  inputs,
  ...
}:
{
  imports = [ "${self}/modules/Desktop/gui.nix" ];

  home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];

  networking = {
    networkmanager.enable = true;
  };

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
}

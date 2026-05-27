{
  self,
  lib,
  osConfig,
  inputs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  config = lib.mkIf (osConfig.programs.niri.enable or false) {
    home = {
      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        GTK_USE_PORTAL = "1";
        NIXOS_OZONE_WL = "1";
      };
    };

    xdg.configFile."niri/config.kdl".source = lib.mkDefault "${self}/modules/Home/niri/config.kdl";

    programs.noctalia = {
      enable = true;
    };
  };
}

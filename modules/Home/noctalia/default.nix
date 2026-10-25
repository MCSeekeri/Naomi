{ lib, osConfig, ... }: {
  config =
    lib.mkIf ((osConfig.programs.niri.enable or false) || (osConfig.programs.umbriel.enable or false))
      {
        home.sessionVariables = {
          CLUTTER_BACKEND = "wayland";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          GTK_USE_PORTAL = "1";
          NIXOS_OZONE_WL = "1";
        };

        programs.noctalia = {
          enable = true;
        };
      };
}

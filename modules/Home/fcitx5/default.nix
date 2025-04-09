{
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      force = true;
    };
    "fcitx5/conf/classicui.conf".source = ./classicui.conf;
  };
  programs = {
    plasma = {
      configFile = {
        "kwinrc"."Wayland"."InputMethod" = {
          value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
        "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
      };
    };
  };
}

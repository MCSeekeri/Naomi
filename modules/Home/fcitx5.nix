{
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
  i18n.inputMethod = {
    type = "fcitx5";
    fcitx5 = {
      themes = "FluentLight-solid";
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "pinyin";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "pinyin";
      };
    };
  };
}

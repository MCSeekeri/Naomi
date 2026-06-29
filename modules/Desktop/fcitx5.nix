{ pkgs, ... }: {
  home-manager.sharedModules = [
    {
      gtk = {
        gtk3.extraConfig = {
          gtk-im-module = "fcitx";
        };
        gtk4.extraConfig = {
          gtk-im-module = "fcitx";
        };
      };
    }
  ];
  # 设置 fcitx5 为默认输入方案
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
        fcitx5-pinyin-minecraft
        fcitx5-fluent
      ];
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
        };
        addons = {
          pinyin.globalSection.FirstRun = "False";
          classicui = {
            globalSection = {
              Font = "Sarasa UI SC 16";
              MenuFont = "Sarasa UI SC 14";
              TrayFont = "Sarasa UI SC 14";
              Theme = "FluentLight-solid";
              DarkTheme = "FluentDark-solid";
              PerScreenDPI = "True";
            };
          };
        };
      };
    };
  };
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx;ibus";
    XMODIFIERS = "@im=fcitx";
  };
}

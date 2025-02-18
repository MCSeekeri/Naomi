{ pkgs, lib, ... }:

let
  defaultFont = {
    family = "Sarasa UI SC";
    pointSize = 13;
  };
in
{
  imports = [
    ../../modules/Home/fcitx5
  ];
  home = {
    username = "remote";
    homeDirectory = "/home/remote";
    stateVersion = "24.11";
    activation = {
      TideConfigure =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''run ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"'';
    };
    extraActivationPath = [ pkgs.babelfish ];

    packages = with pkgs; [
      # 桌面应用
      ungoogled-chromium

      # 开发套件
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      micromamba
      vscode-fhs
    ];
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "";
      userEmail = "";
    };
    fish = {
      enable = true;
      shellAliases = {
        conda = "micromamba";
        proxy = "proxychains4 -q";
      };
    };
    plasma = {
      enable = true;
      overrideConfig = false;
      workspace = {
        enableMiddleClickPaste = true;
        clickItemTo = "select";
        cursor.size = 36;
      };
      kwin = {
        effects = {
          shakeCursor.enable = true;
        };
      };
      session = {
        sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
      };
      input.keyboard.numlockOnStartup = "on";
      fonts = {
        general = defaultFont;
        fixedWidth = {
          inherit (defaultFont) pointSize;
          family = "Sarasa Mono SC";
        };
        small = {
          inherit (defaultFont) family;
          pointSize = 11;
        };
        toolbar = defaultFont;
        menu = defaultFont;
        windowTitle = defaultFont;
      };
      shortcuts = {
        "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      };
      configFile = {
        "klipperrc"."General"."IgnoreImages" = false;
        "klipperrc"."General"."MaxClipItems" = 150;
        "kwinrc"."Wayland"."InputMethod" = {
          value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
        "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
        "kwinrc"."Xwayland"."Scale" = 1.25;
        "plasma-localerc"."Formats"."LANG" = "zh_CN.UTF-8";
        "plasma-localerc"."Translations"."LANGUAGE" = "zh_CN";
        "plasmaparc"."General"."RaiseMaximumVolume" = true;
      };
    };
  };
}

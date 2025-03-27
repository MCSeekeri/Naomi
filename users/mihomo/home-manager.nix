{
  pkgs,
  lib,
  inputs,
  self,
  ...
}:

let
  defaultFont = {
    family = "Sarasa UI SC";
    pointSize = 13;
  };
in
{
  imports = [ "${self}/modules/Home/fcitx5" ];
  home = {
    username = "mihomo";
    homeDirectory = "/home/mihomo";
    stateVersion = "24.11";
    activation = {
      TideConfigure =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''run ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"'';
    };
    extraActivationPath = [ pkgs.babelfish ];

    packages = with pkgs; [ motrix ];
  };

  programs = {
    home-manager.enable = true;
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
        { id = "pfnededegaaopdmhkdmcofjmoldfiped"; } # ZeroOmega
        { id = "ocaahdebbfolfmndjeplogmgcagdmblk"; } # Chromium Web Store
      ];
    };
    fish = {
      enable = true;
      shellAliases = {
        proxy = "proxychains4 -q";
      };
    };
    plasma = {
      enable = true;
      kwin = {
        effects = {
          shakeCursor.enable = true;
        };
      };
      session = {
        general.askForConfirmationOnLogout = true;
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
        "klipperrc"."General"."IgnoreImages" = false; # 剪切板，伟大，无需多言
        "klipperrc"."General"."MaxClipItems" = 150;
        "kwinrc"."Wayland"."InputMethod" = {
          value = "/run/current-system/sw/share/applications/fcitx5-wayland-launcher.desktop";
          shellExpand = true;
        };
        "kwinrc"."Wayland"."VirtualKeyboardEnabled" = true;
        "kwinrc"."Xwayland"."Scale" = 1.25;
        "plasma-localerc"."Formats"."LANG" = "zh_CN.UTF-8";
        "plasma-localerc"."Translations"."LANGUAGE" = "zh_CN";
      };
    };
  };
}

{ lib, ... }:
{
  home = {
    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_RENDERER = "vulkan";
      GTK_USE_PORTAL = "1";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false; # 和 UWSM 不兼容。
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "walker";
      "$mainMod" = "SUPER";
      "$code" = "codium";
      "$browser" = "librewolf";
      "$editor" = "gnome-text-editor";

      exec-once = [
        "waybar"
        "hyprpaper"
        "wl-clip-persist"
        "power-profiles-daemon"
        "nm-applet --no-agent"
        "dbus-update-activation-environment --all"
      ];

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 1;
        gaps_out = 1;
        border_size = 1;
        resize_on_border = true;
      };

      decoration = {
        rounding = 5;

        active_opacity = 1.0;
        inactive_opacity = 0.99;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };

        numlock_by_default = true;
      };

      gestures = {
        workspace_swipe = true;
      };

      # https://github.com/end-4/dots-hyprland
      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1 "
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
        ];
      };

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, E, exec, $fileManager"

        "$mainMod, 1, exec, $menu"
        "$mainMod, 2, exec, $code"
        "$mainMod, 3, exec, $browser"
        "$mainMod, 4, exec, $editor"

        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, V, togglefloating"
        "$mainMod SHIFT, P, pseudo, "
        "$mainMod, J, togglesplit,"

        "$mainMod, mouse_down, movetoworkspace, e+1"
        "$mainMod, mouse_up, movetoworkspace, e-1"

        ", PRINT, exec, hyprshot -m region"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        # 笔记本键盘功能兼容
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrulev2 = [
        "tag +file-manager, class:^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$"
        "tag +terminal, class:^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm)$"
        "tag +browser, class:^(Brave-browser(-beta|-dev|-unstable)?)$"
        "tag +browser, class:^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
        "tag +browser, class:^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
        "tag +projects, class:^(codium|codium-url-handler|VSCodium)$"
        "tag +projects, class:^(VSCode|code-url-handler)$"
        "tag +im, class:^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
        "tag +im, class:^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop|AyuGram)$"
        "tag +games, class:^(gamescope)$"
        "tag +games, class:^(steam_app_\d+)$"
        "tag +gamestore, class:^([Ss]team)$"
        "tag +gamestore, title:^([Ll]utris)$"
        "tag +settings, class:^(gnome-disks|wihotspot(-gui)?)$"
        "tag +settings, class:^([Rr]ofi)$"
        "tag +settings, class:^(file-roller|org.gnome.FileRoller)$"
        "tag +settings, class:^(nm-applet|nm-connection-editor|blueman-manager)$"
        "tag +settings, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "tag +settings, class:^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
        "tag +settings, class:(xdg-desktop-portal-gtk)"
        "tag +settings, class:(.blueman-manager-wrapped)"
        "tag +settings, class:(nwg-displays)"
        "center, class:^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "center, class:([Tt]hunar), title:negative:(.*[Tt]hunar.*)"
        "idleinhibit fullscreen, class:^(*)$"
        "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
        "float, tag:settings*"
        "float, class:(codium|codium-url-handler|VSCodium), title:negative:(.*codium.*|.*VSCodium.*)"
        "float, class:^(com.heroicgameslauncher.hgl)$, title:negative:(Heroic Games Launcher)"
        "float, class:^([Ss]team)$, title:negative:^([Ss]team)$"
        "float, class:([Tt]hunar), title:negative:(.*[Tt]hunar.*)"
        "size 70% 70%, tag:settings*"
        "opacity 1.0 1.0, tag:browser*"
        "opacity 0.9 0.8, tag:projects*"
        "opacity 0.94 0.86, tag:im*"
        "opacity 0.9 0.8, tag:file-manager*"
        "opacity 0.8 0.7, tag:terminal*"
        "opacity 0.8 0.7, tag:settings*"
        "opacity 0.8 0.7, class:^(gedit|org.gnome.TextEditor|mousepad)$"
        "opacity 0.9 0.8, class:^(seahorse)$ # gnome-keyring gui"
        "noblur, tag:games*"
        "fullscreen, tag:games*"
      ];
    };
  };
  services = {
    hyprpolkitagent.enable = true;
    hyprsunset.enable = true;
    hyprpaper.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = lib.mkDefault 180; # 3 min
            on-timeout = "hyprlock";
          }
          {
            timeout = lib.mkDefault 900; # 15 min
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
  programs.hyprlock.enable = true;
}

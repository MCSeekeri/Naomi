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

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
  services = {
    hyprpolkitagent.enable = true;
    hyprsunset.enable = true;
    hypridle.enable = true;
    hyprpaper.enable = true;
  };
  programs.hyprlock.enable = true;
}

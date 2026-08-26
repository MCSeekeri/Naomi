{
  lib,
  osConfig,
  pkgs,
  self,
  ...
}:
{
  imports = [ "${self}/modules/Home/cli-tools.nix" ];

  home.packages = lib.optionals (lib.isDesktop osConfig) (
    with pkgs;
    [
      chafa
      cava
      hollywood
    ]
  );
  services.pueue.enable = true;

  programs = {
    carapace = {
      enable = true;
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };

    bash = {
      enable = true;
      initExtra = ''
        if [[ -n "$(type -p flyline 2>/dev/null)" ]]; then
          flyline key bind Ctrl+r 'always=runBashCommand(__atuin_widget_run)+submitOrNewline'
        fi
      '';
    };

    fastfetch = {
      enable = true;
      # 我完全看不出来有何意义，但 unixporn 上全是这种东西……
      settings = {
        modules = [
          {
            type = "os";
            key = "OS";
            keyColor = "31";
          }
          {
            type = "kernel";
            key = " ├  ";
            keyColor = "31";
          }
          {
            type = "packages";
            key = " ├ 󰏖 ";
            keyColor = "31";
          }
          {
            type = "shell";
            key = " └  ";
            keyColor = "31";
          }
          "break"
          {
            type = "wm";
            key = "WM   ";
            keyColor = "32";
          }
          {
            type = "wmtheme";
            key = " ├ 󰉼 ";
            keyColor = "32";
          }
          {
            type = "icons";
            key = " ├ 󰀻 ";
            keyColor = "32";
          }
          {
            type = "cursor";
            key = " ├  ";
            keyColor = "32";
          }
          {
            type = "terminal";
            key = " └  ";
            keyColor = "32";
          }
          "break"
          {
            type = "host";
            format = "{5} {1} Type {2}";
            key = "PC   ";
            keyColor = "33";
          }
          {
            type = "cpu";
            format = "{1} ({3}) @ {7}";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "gpu";
            format = "{1} {2}";
            key = " ├ 󰢮 ";
            keyColor = "33";
          }
          {
            type = "memory";
            key = " ├  ";
            keyColor = "33";
          }
          {
            type = "disk";
            key = " ├ 󰋊 ";
            keyColor = "33";
          }
          {
            type = "monitor";
            key = " └  ";
            keyColor = "33";
          }
          "break"
          {
            type = "uptime";
            key = "   Uptime   ";
          }
        ];
      };
    };
  };
}

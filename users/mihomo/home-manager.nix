{ pkgs, self, ... }:
{
  imports = [
    "${self}/modules/Home/fcitx5"
    "${self}/modules/Home/default.nix"
    "${self}/modules/Home/plasma-manager"
    "${self}/modules/Home/browser/chromium.nix"
    "${self}/modules/Home/vscode.nix"
    "${self}/modules/Home/fish/tide.nix"
  ];
  home = {
    username = "mihomo";
    homeDirectory = "/home/mihomo";
    packages = with pkgs; [ motrix ];
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        proxy = "proxychains4 -q";
      };
    };
    plasma = {
      enable = true;
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

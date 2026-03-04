{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  config = {
    stylix = lib.mkMerge (
      [
        {
          enable = lib.mkDefault true;
          autoEnable = lib.mkDefault true;
          base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/rebecca.yaml";
          polarity = lib.mkDefault "dark";
        }
      ]
      ++
        lib.optional
          ((config.services.xserver.enable or false) || (config.programs.hyprland.enable or false))
          {
            image = lib.mkDefault (
              pkgs.fetchurl {
                url = "https://github.com/MCSeekeri/storage/raw/main/wallpaper/nixos-catppuccin-macchiato-rainbow.png";
                sha256 = "19z7zvj8qci156c35n5l5s9398dz30xj0zjk2fwkwlrk6c3ijpwv";
              }
            ); # https://github.com/lunik1/nix-wallpaper
            fonts = {
              sizes = {
                applications = lib.mkDefault 14;
                desktop = lib.mkDefault 14;
                popups = lib.mkDefault 14;
                terminal = lib.mkDefault 14;
              };
              sansSerif = {
                package = lib.mkDefault pkgs.source-han-sans;
                name = lib.mkDefault "Source Han Sans SC";
              };
              serif = {
                package = lib.mkDefault pkgs.source-han-serif;
                name = lib.mkDefault "Source Han Serif SC";
              };
              monospace = {
                package = lib.mkDefault pkgs.maple-mono.Normal-NF-CN-unhinted;
                name = lib.mkDefault "Maple Mono SC NF";
              };
              emoji = {
                package = lib.mkDefault pkgs.noto-fonts-color-emoji;
                name = lib.mkDefault "Noto Color Emoji";
              };
            };
          }
    );
  };
}

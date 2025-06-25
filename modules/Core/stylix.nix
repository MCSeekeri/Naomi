{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/MCSeekeri/storage/raw/main/wallpaper/nixos-catppuccin-macchiato-rainbow.png";
      sha256 = "19z7zvj8qci156c35n5l5s9398dz30xj0zjk2fwkwlrk6c3ijpwv";
    }; # https://github.com/lunik1/nix-wallpaper
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rebecca.yaml";
    polarity = "dark";
    fonts = {
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 14;
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
        package = lib.mkDefault pkgs.noto-fonts-emoji;
        name = lib.mkDefault "Noto Color Emoji";
      };
    };
  };
}

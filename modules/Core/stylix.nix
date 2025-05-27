{ pkgs, inputs, ... }:
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
        package = pkgs.source-han-sans;
        name = "Source Han Sans SC";
      };
      serif = {
        package = pkgs.source-han-serif;
        name = "Source Han Serif SC";
      };
      monospace = {
        package = pkgs.maple-mono.Normal-NF-CN;
        name = "Maple Mono SC NF";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}

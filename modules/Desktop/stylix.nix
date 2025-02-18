{ pkgs, inputs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;
    image = pkgs.fetchurl {
      url = "https://github.com/MCSeekeri/storage/raw/main/wallpaper/ahh_a_snake.jpg";
      sha256 = "1gifgvnp5dr0hzj1nif5448jd4vclppnfw1msvxyicb4m1k1hibm";
    }; # https://www.deviantart.com/chasingartwork/art/ahh-a-snake-383715432
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 36;
    };
    fonts = {
      sizes = {
        applications = 14;
        desktop = 14;
        popups = 14;
        terminal = 14;
      };
      sansSerif = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa Gothic SC";
      };
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK SC";
      };
      monospace = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa Mono SC";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}

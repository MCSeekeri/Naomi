{ pkgs, ... }:
{
  programs.java = {
    enable = true;
    binfmt = true;
  };

  environment = {
    systemPackages = with pkgs; [
      hmcl
      prismlauncher
      mcaselector
      packwiz
      jdk
      zulu8
      zulu11
      zulu17
      zulu25
    ];
  };
}

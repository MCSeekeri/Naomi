{ pkgs, ... }:
{
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
    ];
  };
}

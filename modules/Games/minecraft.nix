{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      hmcl
      prismlauncher
      # mcaselector # [TODO] 等待 Gradle 完全弃用
      packwiz
      jdk
      zulu8
      zulu11
      zulu17
    ];
  };
}

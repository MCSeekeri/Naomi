{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      hmcl
      prismlauncher
      jdk # 当前为 21 版本
      jdk8
      jdk17
      jdk23
    ];
  };
}

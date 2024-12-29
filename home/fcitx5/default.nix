{ pkgs, ... }:
{
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      force = true;
    };
    "fcitx5/conf/classicui.conf".source = ./classicui.conf;
  };
}

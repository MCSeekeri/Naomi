{ pkgs, ... }:
{
  programs = {
    localsend = {
      enable = true;
      package = pkgs.localsend;
      # openFirewall = true; #默认启用
    };
  };
}

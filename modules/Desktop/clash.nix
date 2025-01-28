{ pkgs, ... }:
{
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
    package = pkgs.clash-verge-rev;
  };
}

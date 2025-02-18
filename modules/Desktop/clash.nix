{ pkgs, ... }:
{
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = false;
    package = pkgs.clash-verge-rev;
  };
}

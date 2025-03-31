{ pkgs, ... }:
{
  packages = with pkgs; [
    nix
    git
    sops
    age
    home-manager
  ];
  languages.nix.enable = true;
}

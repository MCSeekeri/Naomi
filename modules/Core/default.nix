{ inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ./boot.nix
    ./fonts.nix
    ./i18n.nix
    ./kmscon.nix
    ./nix.nix
    ./podman.nix
    ./programs.nix
    ./sops.nix
    ./ssh.nix
    ./tailscale.nix
    ./zram.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs; };
  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  networking = {
    networkmanager.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    graphics.enable32Bit = true;
  };

}

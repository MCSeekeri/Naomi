{ inputs, outputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.flake-programs-sqlite.nixosModules.programs-sqlite
    inputs.arion.nixosModules.arion
    inputs.daeuniverse.nixosModules.dae
    # inputs.daeuniverse.nixosModules.daed
    ./avahi.nix
    ./boot.nix
    ./dae
    ./fonts.nix
    ./geph5.nix
    ./i18n.nix
    ./kmscon.nix
    ./mDNS.nix
    ./nix.nix
    ./podman.nix
    ./programs.nix
    ./sops.nix
    ./ssh.nix
    ./tailscale.nix
    ./zram.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs outputs; };
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
  };

  networking = {
    networkmanager.enable = true;
  };
  hardware = {
    enableAllFirmware = true;
    graphics.enable32Bit = true;
  };

}

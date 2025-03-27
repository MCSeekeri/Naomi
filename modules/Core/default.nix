{
  inputs,
  outputs,
  self,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.arion.nixosModules.arion
    inputs.daeuniverse.nixosModules.dae
    # inputs.daeuniverse.nixosModules.daed
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
    ./stylix.nix
    ./tailscale.nix
    ./zram.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit self inputs outputs; };
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

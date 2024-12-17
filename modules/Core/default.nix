{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./boot.nix
    ./hardened.nix
    ./i18n.nix
    ./nix.nix
    ./programs.nix
    ./ssh.nix
    ./tailscale.nix
    ./time.nix
    ./users.nix
    ./virt.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };
  home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
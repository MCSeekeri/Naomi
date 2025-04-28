{ inputs, lib, ... }:
let
  hostnames = [
    "manhattan"
    "seychelles"
    "cyprus"
    "cuba"
    "costarica"
  ];
in
{
  flake = {
    nixosConfigurations = lib.genAttrs hostnames (
      name:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit (inputs) self;
        };
        modules = [ ./${name} ];
      }
    );
  };
}

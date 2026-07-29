{ inputs, lib, ... }: {
  flake = {
    nixosConfigurations =
      lib.genAttrs
        (builtins.attrNames (lib.filterAttrs (_name: type: type == "directory") (builtins.readDir ./.)))
        (
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

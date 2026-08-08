{ inputs, lib, ... }: {
  flake = {
    nixosConfigurations =
      lib.genAttrs
        (builtins.attrNames (
          lib.filterAttrs (
            name: type:
            type == "directory"
            && !lib.strings.hasPrefix "." name
            && builtins.pathExists (./. + "/${name}/default.nix")
          ) (builtins.readDir ./.)
        ))
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

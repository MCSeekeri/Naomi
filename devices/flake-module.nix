{ inputs, lib, ... }: {
  flake.nixOnDroidConfigurations =
    lib.genAttrs
      (builtins.attrNames (
        lib.filterAttrs (
          name: type:
          type == "directory" && !lib.hasPrefix "." name && builtins.pathExists (./. + "/${name}/default.nix")
        ) (builtins.readDir ./.)
      ))
      (
        name:
        inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [ ./${name} ];
          extraSpecialArgs = {
            inherit inputs;
            inherit (inputs) self;
          };
          pkgs = import inputs.nixpkgs {
            system = "aarch64-linux";
            config.allowUnfree = true;
            overlays = [ inputs.nix-on-droid.overlays.default ];
          };
          home-manager-path = inputs.home-manager.outPath;
        }
      );
}

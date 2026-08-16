{ lib, ... }: {
  perSystem =
    { pkgs, ... }:
    let
      pkgSet = lib.genAttrs (builtins.attrNames (
        lib.filterAttrs (
          name: type:
          type == "directory" && !lib.hasPrefix "." name && builtins.pathExists (./. + "/${name}/default.nix")
        ) (builtins.readDir ./.)
      )) (name: pkgs.callPackage (./. + "/${name}") { });
    in
    {
      packages = pkgSet;
      overlayAttrs = pkgSet;
    };
}

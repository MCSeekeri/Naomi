{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      pkgSet = lib.genAttrs (builtins.filter (name: builtins.pathExists (./. + "/${name}/default.nix")) (
        builtins.attrNames (builtins.readDir ./.)
      )) (name: pkgs.callPackage (./. + "/${name}") { });
    in
    {
      packages = pkgSet;
      overlayAttrs = pkgSet;
    };
}

{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = lib.filterAttrs (_name: value: value != null) (
        builtins.mapAttrs (
          name: _type:
          if builtins.pathExists (./. + "/${name}/default.nix") then
            pkgs.callPackage (./. + "/${name}") { }
          else
            null
        ) (builtins.readDir ./.)
      );
    };
}

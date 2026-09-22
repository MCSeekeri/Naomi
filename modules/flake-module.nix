{ lib, inputs, ... }:
let
  join = prefix: name: if prefix == "" then name else "${prefix}/${name}";

  scan =
    prefix: dir:
    lib.pipe (builtins.readDir dir) [
      (lib.filterAttrs (name: _: !lib.hasPrefix "." name))
      (lib.mapAttrs (
        name: type:
        if type == "directory" then
          (
            if builtins.pathExists (dir + "/${name}/default.nix") then
              { "${join prefix name}" = dir + "/${name}"; }
            else
              scan (join prefix name) (dir + "/${name}")
          )
        else if
          type == "regular"
          && lib.hasSuffix ".nix" name
          && name != "default.nix"
          && name != "flake-module.nix"
        then
          { "${join prefix name}" = dir + "/${name}"; }
        else
          { }
      ))
      lib.attrValues
      (builtins.foldl' (acc: mods: acc // mods) { })
    ];

  wrap =
    module: args:
    let
      inner = import module;
      injected = {
        inherit (inputs.self) lib;
        inherit (inputs) self;
      };
      missingArgs = builtins.filter (name: !(args ? ${name} || injected ? ${name})) (
        builtins.attrNames (builtins.functionArgs inner)
      );
    in
    if builtins.isFunction inner then
      inner (args // injected // lib.genAttrs missingArgs (name: args.config._module.args.${name}))
    else
      inner;
in
{
  flake.nixosModules = lib.mapAttrs (_: wrap) (scan "" ./.);
}

{ inputs, lib, ... }: {
  flake.nixosModules =
    let
      collect =
        dir: prefix:
        let
          join = name: if prefix == "" then name else "${prefix}/${name}";
          entries = builtins.readDir dir;
          subDirs = lib.filterAttrs (name: type: type == "directory" && !lib.hasPrefix "." name) entries;
          files = lib.filterAttrs (
            name: type:
            type == "regular"
            && lib.hasSuffix ".nix" name
            && !lib.hasPrefix "." name
            && name != "default.nix"
            && name != "flake-module.nix"
          ) entries;
          dirModules = lib.foldl' (
            acc: name:
            if builtins.pathExists (dir + "/${name}/default.nix") then
              acc // { "${join name}" = wrap (dir + "/${name}"); }
            else
              acc // collect (dir + "/${name}") (join name)
          ) { } (lib.attrNames subDirs);
          fileModules = lib.mapAttrs' (
            name: _: lib.nameValuePair (join name) (wrap (dir + "/${name}"))
          ) files;
        in
        dirModules // fileModules;

      wrap =
        file:
        args@{ config, lib, ... }:
        let
          m = import file;
          injected = {
            inherit (inputs.self) lib;
            inherit (inputs) self;
          };
          missingArgs = builtins.filter (name: !(args ? ${name} || injected ? ${name})) (
            builtins.attrNames (builtins.functionArgs m)
          );
          extraArgs = lib.genAttrs missingArgs (name: config._module.args.${name});
        in
        if lib.isFunction m then m (args // injected // extraArgs) else m;
    in
    collect ./. "";
}

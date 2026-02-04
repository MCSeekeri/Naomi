{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt = {
      enable = true;
      strict = true;
    };
    deadnix.enable = true;
    statix.enable = true;
    mdformat = {
      enable = true;
      plugins = ps: [ ps.mdformat-gfm ];
      settings = {
        wrap = "keep";
        number = true;
        end-of-line = "lf";
      };
    };
  };
}

{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt = {
      enable = true;
      strict = true;
    };
    deadnix.enable = true;
    statix.enable = true;
    shellcheck = {
      enable = true;
      extra-checks = [ "all" ];
      excludes = [ ".envrc" ];
    };
    shfmt = {
      enable = true;
      indent_size = 2;
      simplify = true;
    };
    fish_indent.enable = true;
    yamlfmt = {
      enable = true;
      excludes = [
        ".sops.yaml"
        "secrets/*.yaml"
        "secrets/*.yml"
        "secrets/**/*.yaml"
        "secrets/**/*.yml"
      ];
      settings = {
        formatter = {
          type = "basic";
          retain_line_breaks = true;
          scan_folded_as_literal = true;
        };
      };
    };
    yamllint = {
      enable = true;
      excludes = [
        ".sops.yaml"
        "secrets/*.yaml"
        "secrets/*.yml"
        "secrets/**/*.yaml"
        "secrets/**/*.yml"
      ];
      settings = {
        extends = "default";
        rules = {
          document-start = "disable";
          indentation = {
            spaces = 2;
            indent-sequences = true;
            check-multi-line-strings = false;
          };
          line-length = {
            max = 110;
            allow-non-breakable-words = true;
            allow-non-breakable-inline-mappings = false;
          };
          truthy = {
            allowed-values = [
              "true"
              "false"
            ];
            check-keys = false;
          };
          key-duplicates = "enable";
          trailing-spaces = "enable";
          new-line-at-end-of-file = "enable";
          comments-indentation = "enable";
          braces = {
            min-spaces-inside = 0;
            max-spaces-inside = 1;
          };
          brackets = {
            min-spaces-inside = 0;
            max-spaces-inside = 0;
          };
        };
      };
    };

    dos2unix.enable = true;
    actionlint = {
      enable = true;
      excludes = [ ".forgejo/workflows/**" ];
    };
    keep-sorted.enable = true;
    autocorrect = {
      enable = true;
      settings = {
        rules = {
          space-word = "error";
          space-punctuation = "error";
          space-bracket = "error";
          space-backticks = "error";
          space-dash = "error";
          space-dollar = "error";
          fullwidth = "error";
          no-space-fullwidth = "error";
          halfwidth-word = "error";
          halfwidth-punctuation = "error";
          spellcheck = "error";
        };
        context.codeblock = "error";
      };
    };
    sizelint = {
      enable = true;
      failOnWarn = true;
    };
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

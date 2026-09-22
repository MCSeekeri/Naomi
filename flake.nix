{
  description = "Naomi Flake Configuration";

  nixConfig = {
    extra-substituters = [ "https://nix.mcseekeri.com?priority=51" ];
    extra-trusted-public-keys = [ "nix.mcseekeri.com-1:3gd0/2u7IOF7YooxEiBbWTvRCYGC53S2UoqFdnCUYHc=" ];
    extra-experimental-features = [ "pipe-operators" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # 官方源
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-compat.url = "github:NixOS/flake-compat";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        nix-index-database.follows = "nix-index-database";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nur.follows = "nur";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };

    niks3 = {
      url = "github:Mic92/niks3";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/pull/529/head"; # 修复 proot 问题
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    flyline = {
      url = "github:HalFrgrd/flyline";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }: {
        flake.lib = import ./lib { inherit lib; };

        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.treefmt-nix.flakeModule
          ./hosts/flake-module.nix
          ./modules/flake-module.nix
          ./devices/flake-module.nix
          ./pkgs/flake-module.nix
        ];
        systems = [ "x86_64-linux" ];

        perSystem =
          {
            pkgs,
            system,
            config,
            lib,
            ...
          }:
          let
            devPackages = with pkgs; [
              nix
              git
              fish
              sops
              age
              home-manager
              nix-init
              nh
              nixfmt
              fh
              libressl # openssl rand -hex 64
              nix-melt
              nix-tree
              config.packages.ndp
              config.treefmt.build.wrapper
            ];
          in
          {
            treefmt.config = import ./treefmt.nix;
            formatter = config.treefmt.build.wrapper;

            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            devShells.default = pkgs.mkShell {
              packages = devPackages;

              shellHook = ''
                export fish_complete_path="${lib.makeSearchPath "share/fish/vendor_completions.d" devPackages}:$fish_complete_path"
              '';
            };
          };
      }
    );
}

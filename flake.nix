{
  description = "Naomi Flake Configuration";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
      "https://cache.nixos.org?priority=3"
      "https://nix-community.cachix.org?priority=4"
      "https://numtide.cachix.org?priority=5"
      "https://cache.garnix.io?priority=6"
      "https://cache.lix.systems?priority=7"
      "https://nix-gaming.cachix.org?priority=8"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"; # 官方源
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default"; # 两年没更新，都不知道为什么有 Flake 引用这个……
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        gitignore.follows = "gitignore";
      };
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        devshell.follows = "devshell";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        nur.follows = "nur";
      };
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-2.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # [TODO] 在 25.11 发布后移除
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks-nix.follows = "pre-commit-hooks";
        rust-overlay.follows = "rust-overlay";
      };
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        rust-overlay.follows = "rust-overlay";
      };
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        imports = [
          inputs.devshell.flakeModule
          inputs.nix-topology.flakeModule
          inputs.flake-parts.flakeModules.easyOverlay
          ./hosts/flake-module.nix
          ./pkgs/flake-module.nix
        ];
        systems = [ "x86_64-linux" ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            packages = {
              topology = self.topology.${system}.config.output;
            };

            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.nix-vscode-extensions.overlays.default ];
              config.allowUnfree = true;
            };

            devshells.default = {
              packages = with pkgs; [
                lix
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
                deadnix
                alejandra
                statix
                nix-melt
                nix-tree
                colmena
              ];
            };
            topology = {
              modules = [ { imports = [ ./topology.nix ]; } ];
            };
          };
      }
    );
}

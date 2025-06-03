{
  description = "Naomi Flake Configuration";

  nixConfig = {
    auto-optimise-store = true; # 会让 build 变慢，见仁见智吧
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    connect-timeout = 20;
    http-connections = 64;
    max-substitution-jobs = 32;
    max-jobs = "auto";
    builders-use-substitutes = true;
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
      "https://cache.nixos.org/?priority=3"
      "https://nix-community.cachix.org?priority=4"
      "https://numtide.cachix.org?priority=5"
      "https://cache.garnix.io?priority=6"
      "https://cache.lix.systems/?priority=7"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # 官方源
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "github:edolstra/flake-compat";
    systems.url = "github:nix-systems/default"; # 两年没更新，都不知道为什么有 Flake 引用这个……
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        devshell.follows = "devshell";
      };
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        systems.follows = "systems";
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
        flake-utils.follows = "flake-utils";
      };
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        withSystem,
        self,
        config,
        ...
      }:
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
            inputs',
            self',
            pkgs,
            lib,
            system,
            final,
            ...
          }:
          {
            overlayAttrs = { inherit (config.packages) lain-kde-splashscreen aquanet aquadx; };

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
                nix
                git
                fish
                sops
                age
                home-manager
                nix-init
                nh
                nixfmt-rfc-style
                fh
                libressl # openssl rand -hex 64
                deadnix
                alejandra
                statix
              ];
            };
            topology = {
              nixosConfigurations = { };
              modules = [ { imports = [ ./topology.nix ]; } ];
            };
          };
      }
    );
}

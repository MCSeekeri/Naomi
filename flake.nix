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
    builders-use-substitutes = true;
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
      "https://cache.nixos.org/?priority=3"
      "https://cache.garnix.io?priority=4"
      "https://nix-community.cachix.org?priority=5"
      "https://numtide.cachix.org?priority=6"
      "https://devenv.cachix.org?priority=7"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # 官方源

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      # 我们又回到了老路上？
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-topology,
      devenv,
      nixos-generators,
      ...
    }@inputs:
    let
      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (./hosts + "/${hostName}")
            inputs.nix-topology.nixosModules.default
            {
              nixpkgs.overlays = [
                inputs.nix-vscode-extensions.overlays.default
                mc-overlay
              ];
            }
          ];
          specialArgs = { inherit self inputs hostName; };
        };

      # 为拓扑定制的 pkgs 实例
      topology-pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nix-topology.overlays.default ];
      };
      mc-overlay = final: prev: {
        geph5-client = final.callPackage ./pkgs/geph5-client { };
        lain-kde-splashscreen = final.callPackage ./pkgs/lain-kde-splashscreen { };
        aquanet = final.callPackage ./pkgs/aquanet { };
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ mc-overlay ];
      };

    in
    {
      nixosConfigurations = {
        manhattan = mkHost "manhattan";
        seychelles = mkHost "seychelles";
        cyprus = mkHost "cyprus";
        cuba = mkHost "cuba";
        costarica = mkHost "costarica";
      };

      # 拓扑生成配置
      topology."x86_64-linux" = import nix-topology {
        pkgs = topology-pkgs;
        modules = [
          ./topology.nix
          { inherit (self) nixosConfigurations; }
        ];
      };
      # nix build .#包名
      packages.x86_64-linux = {
        topology = self.topology.x86_64-linux.config.output;
        geph5-client = pkgs.geph5-client;
        lain-kde-splashscreen = pkgs.lain-kde-splashscreen;
        aquanet = pkgs.aquanet;
        cuba = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "install-iso";
          modules = [
            (./hosts + "/cuba")
            { nixpkgs.overlays = [ mc-overlay ]; }
          ];
          specialArgs = { inherit self inputs; };
        };
      };
      devShells.x86_64-linux.default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [ ./devenv.nix ];
      };
    };
}

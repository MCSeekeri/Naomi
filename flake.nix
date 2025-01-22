{
  description = "Naomi Flake Configuration";
  nixConfig = {
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    trusted-users = [
      "root"
      "mcseekeri"
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
    # nix-mineral = {
    #   url = "github:cynicsketch/nix-mineral";
    #   flake = false;
    # };
    # 不稳定，之后加入
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    nix-software-center.url = "github:snowfallorg/nix-software-center";
    nixos-generators = {
      # 我们又回到了老路上？
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-mineral = {
    #   url = "github:cynicsketch/nix-mineral"; # Refers to the main branch and is updated to the latest commit when you use "nix flake update"
    #   flake = false;
    # };
    # 等待 nm-override.nix 重做
    sops-nix.url = "github:Mic92/sops-nix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      inherit lib;
      nixosConfigurations = {
        manhattan = lib.nixosSystem {
          modules = [ ./hosts/manhattan ];
          specialArgs = { inherit inputs outputs plasma-manager; };
        };
        seychelles = lib.nixosSystem {
          modules = [ ./hosts/seychelles ];
          specialArgs = { inherit inputs outputs; };
        };
        cyprus = lib.nixosSystem {
          modules = [ ./hosts/cyprus ];
          specialArgs = { inherit inputs outputs plasma-manager; };
        };
        cuba = lib.nixosSystem {
          modules = [ ./hosts/cuba ];
          specialArgs = { inherit inputs outputs; };
        };
        costarica = lib.nixosSystem {
          modules = [ ./hosts/costarica ];
          specialArgs = { inherit inputs outputs; };
        };
      };
    };
}

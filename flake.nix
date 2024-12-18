{
  description = "Naomi Flake Configuration";

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
    # nix-mineral = {
    #   url = "github:cynicsketch/nix-mineral"; # Refers to the main branch and is updated to the latest commit when you use "nix flake update" 
    #   flake = false;
    # };
    # 等待 nm-override.nix 重做
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      nix-alien,
      nixos-generators,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      inherit lib;
      nixosConfigurations = {
        VM = lib.nixosSystem {
          modules = [ ./hosts/VM ];
          specialArgs = {
            inherit inputs outputs plasma-manager;
          };
        };
        ISO = lib.nixosSystem {
          modules = [ ./hosts/ISO ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
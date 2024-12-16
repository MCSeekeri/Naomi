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
    {
      nixosConfigurations.Naomi = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux"; # 显而易见
        specialArgs = { inherit inputs; }; # 传入 inputs 到文件
        modules = [
          ./configuration.nix # 啥
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.users.mcseekeri = import users/mcseekeri.nix;

            # home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
      programs.nix-ld.enable = true;
    };
}

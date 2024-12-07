{
  description = "Naomi Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # 官方源
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.Naomi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # 显而易见
        modules = [
          ./configuration.nix # 啥
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mcseekeri = import users/mcseekeri.nix;

            # home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
}
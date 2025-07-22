{
  inputs,
  outputs,
  self,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.arion.nixosModules.arion
    inputs.daeuniverse.nixosModules.dae
    # inputs.daeuniverse.nixosModules.daed
    inputs.lix-module.nixosModules.default
    inputs.nur.modules.nixos.default
    ./apparmor.nix
    ./boot.nix
    ./dae
    ./fonts.nix
    ./geph5.nix
    ./i18n.nix
    ./kmscon.nix
    ./mDNS.nix
    ./nix.nix
    ./podman.nix
    ./programs.nix
    ./sops.nix
    ./ssh.nix
    ./stylix.nix
    ./tailscale.nix
    ./users.nix
    ./zram.nix
  ];

  system = {
    autoUpgrade = {
      flake = "github:MCSeekeri/Naomi";
      operation = lib.mkDefault "boot";
      dates = lib.mkDefault "weekly";
    };
    rebuild.enableNg = true;
  };

  nixpkgs.overlays = [
    self.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit self inputs outputs; };
    sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
  };

  networking = {
    networkmanager.enable = true;
    useNetworkd = true; # 实验性启用
    dhcpcd.enable = false;
  };

  hardware = {
    enableAllFirmware = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  security = {
    sudo-rs = {
      enable = true;
      execWheelOnly = true; # https://unix.stackexchange.com/questions/1262/where-did-the-wheel-group-get-its-name
    };
  };

  systemd.services.nix-gc.serviceConfig = {
    CPUSchedulingPolicy = "batch";
    IOSchedulingClass = "idle";
    IOSchedulingPriority = 7;
  };
}

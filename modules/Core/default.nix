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
    inputs.lix-module.nixosModules.default
    #inputs.determinate.nixosModules.default
    inputs.nur.modules.nixos.default
    ./apparmor.nix
    ./avahi.nix
    ./boot.nix
    ./dae
    ./fonts.nix
    ./geph5.nix
    ./i18n.nix
    ./kmscon.nix
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
    # useUserPackages = true; # 系统级别的软件包安装，starship 之类的需要用到
    # [TODO]: 整明白为什么开了之后用户登录就卡住
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit self inputs outputs; };
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
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
      # 不是很支持 sudo -E
      enable = true;
      execWheelOnly = true; # https://unix.stackexchange.com/questions/1262/where-did-the-wheel-group-get-its-name
    };
  };

  systemd = {
    coredump.enable = false; # 不需要转储
    services.nix-gc.serviceConfig = {
      CPUSchedulingPolicy = "batch";
      IOSchedulingClass = "idle";
      IOSchedulingPriority = 7;
    };
  };

  environment.enableAllTerminfo = true;
}

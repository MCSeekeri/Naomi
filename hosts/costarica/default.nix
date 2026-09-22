{ self, modulesPath, ... }: {
  imports = [
    ./disko-config.nix
    (modulesPath + "/profiles/qemu-guest.nix")

    "${self}/modules/Core"
    "${self}/modules/Core/prc.nix"

    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/fcitx5.nix"

    "${self}/modules/Services/nginx.nix"
    "${self}/modules/Services/dae"
    "${self}/modules/Services/geph5.nix"

    "${self}/users/mihomo"
  ];

  # 网络配置
  networking = {
    hostName = "costarica"; # 主机名，设置好之后最好不要修改
  };

  system = {
    stateVersion = "26.05";
  };
  hardware.cpu.type = "qemu";

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
    limine.enable = false;
    efi.canTouchEfiVariables = true;
  };
}

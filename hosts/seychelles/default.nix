{ lib, self, ... }:
{
  imports = [
    ./disko-config.nix
    "${self}/modules/Core"
    "${self}/modules/Hardware"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/programs.nix"

    "${self}/users/mcseekeri"
  ];

  # 网络配置
  networking = {
    hostName = "seychelles"; # 主机名，设置好之后最好不要修改
  };

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };

  hardware = {
    cpu = {
      type = "intel";
      arch = "x86_64-v4";
    };
    gpu.type = "nvidia";
  };
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  networking.useDHCP = lib.mkDefault true;
}

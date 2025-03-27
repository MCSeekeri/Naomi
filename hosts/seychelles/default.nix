{ lib, self, ... }:
{
  imports = [
    ./disko-config.nix
    "${self}/modules/Core"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/hardened.nix"
    "${self}/modules/Server/virt.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Desktop/gui.nix"
    "${self}/modules/Desktop/programs.nix"

    "${self}/modules/Hardware/nvidia.nix"

    "${self}/users/mcseekeri"
  ];

  # 网络配置
  networking = {
    hostName = "seychelles"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault true;
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

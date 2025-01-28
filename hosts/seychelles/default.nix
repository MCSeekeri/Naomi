{ lib, ... }:
{
  imports = [
    ./disko-config.nix
    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Server/hardened.nix
    ../../modules/Server/virt.nix
    ../../modules/Server/failsafe.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/programs.nix

    ../../modules/Hardware/nvidia.nix

    ../../users/mcseekeri
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

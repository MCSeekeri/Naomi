{ lib, self, ... }:
{
  imports = [
    ./disko-config.nix
    "${self}/modules/Core"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/hardened.nix"
    "${self}/modules/Server/virt.nix"
    "${self}/modules/Desktop/gui.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Hardware/nvidia_laptop.nix"

    "${self}/users/mcseekeri"
  ];

  # 网络配置
  networking = {
    hostName = "cyprus"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault true;
  };
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "uas"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}

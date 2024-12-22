{
  ...
}:
{
  imports = [
    ../../modules/Core

    ../../modules/Server/firewall.nix
    ../../modules/Server/clamav.nix
    ../../modules/Server/hardened.nix
    ../../modules/Server/virt.nix
    ../../modules/Desktop/gui.nix
    ../../modules/Desktop/sunshine.nix
    ../../modules/Desktop/programs.nix
    ../../modules/Desktop/gaming.nix
    ../../modules/Desktop/nvidia.nix

    ../../users/mcseekeri
  ];

  # 网络配置
  networking = {
    hostName = "cyprus"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "uas"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };
}

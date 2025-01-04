{ lib, ... }:
{
  imports = [ ./nvidia.nix ];
  hardware.nvidia = {
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0"; # https://wiki.nixos.org/wiki/Nvidia
    };
  };
  specialisation.offload.configuration = {
    system.nixos.tags = [ "offload" ];
    hardware.nvidia = {
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        offload = {
          enable = lib.mkForce true;
          enableOffloadCmd = lib.mkForce true;
        };
        sync.enable = lib.mkForce false;
      };
    };
  };
}

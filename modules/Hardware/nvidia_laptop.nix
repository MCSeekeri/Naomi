{ lib, ... }:
{
  imports = [ ./nvidia.nix ];
  # environment.systemPackages = with pkgs; [ nixgl.nixGLNvidiaBumblebee ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      intelBusId = lib.mkDefault "PCI:0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1:0:0"; # https://wiki.nixos.org/wiki/Nvidia
    };
    # 主机配置里写比较合适
  };
  specialisation.offload.configuration = {
    system.nixos.tags = [ "offload" ];
    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];
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

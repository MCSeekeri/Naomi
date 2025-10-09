{ lib, ... }:
{
  imports = [ ./nvidia.nix ];
  # environment.systemPackages = with pkgs; [ nixgl.nixGLNvidiaBumblebee ];

  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = lib.mkDefault false;

      intelBusId = lib.mkDefault "PCI:0:2:0";
      nvidiaBusId = lib.mkDefault "PCI:1:0:0"; # https://wiki.nixos.org/wiki/Nvidia
    };
    # 主机配置里写比较合适
  };
  # specialisation.offload.configuration = {
  #   system.nixos.tags = [ "sync" ];
  #   services.xserver.videoDrivers = [
  #     "modesetting"
  #     "nvidia"
  #   ];
  #   hardware.nvidia = {
  #     powerManagement = {
  #       enable = true;
  #       finegrained = true;
  #     };
  #     prime = {
  #       sync.enable = true;
  #       offload = {
  #         enable = lib.mkForce false;
  #         enableOffloadCmd = lib.mkForce false;
  #       };
  #     };
  #   };
  # };
}

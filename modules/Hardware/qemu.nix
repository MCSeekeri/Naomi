{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Hardware/acceleration.nix" ];
  hardware.graphics = {
    extraPackages = with pkgs; [ virglrenderer ];
  };
}

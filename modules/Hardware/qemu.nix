{ pkgs, self, ... }:
{
  imports = [ "${self}/modules/Hardware/acceleration.nix" ];
  hardware.graphics = {
    extraPackages = with pkgs; [
      virglrenderer
      virtualgl
    ];
  };
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-autorandr.enable = true;
    spice-webdavd.enable = true;
  };
}

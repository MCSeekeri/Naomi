{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      mpv # 测试硬件加速用的
    ];
  };
  hardware.graphics = {
    extraPackages = with pkgs; [
      mesa
      libva-utils
      vdpauinfo
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      libvdpau-va-gl
      vdpauinfo
    ];
  };
}

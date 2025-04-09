{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      libva-utils
      vdpauinfo
      driversi686Linux.vdpauinfo
      vulkan-tools
      mpv # 测试硬件加速用的
    ];
  };
}

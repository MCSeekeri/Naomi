{ ... }:
{
  services = {
    xserver = {
      enable = true;
      # videoDrivers = [  "nvidia" "modesetting" "fbdev"];
    };
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true; # 开启 flatpak 支持，有效解决 nixOS 桌面软件水土不服的问题
  };
  xdg.portal.enable = true;
  qt.platformTheme = "kde";
  security.rtkit.enable = true;
}

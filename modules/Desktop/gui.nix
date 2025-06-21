{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services = {
    xserver = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true; # 开启 flatpak 支持，有效解决 nixOS 桌面软件水土不服的问题
  };
  xdg.portal = {
    enable = true;
  };
  security.rtkit.enable = true;
  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome
      noto-fonts-emoji
      fira-code
      jetbrains-mono
      sarasa-gothic
      cascadia-code
    ];
  };
  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ]; # https://github.com/nix-community/home-manager/blob/release-25.05/modules/misc/xdg-portal.nix
}

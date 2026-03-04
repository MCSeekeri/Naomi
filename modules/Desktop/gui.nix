{
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [ "${self}/modules/Desktop/flatpak.nix" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  services = {
    xserver = {
      enable = true;
    };
    power-profiles-daemon.enable = lib.mkDefault true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    upower.enable = lib.mkDefault true;
  };
  powerManagement.powertop.enable = lib.mkDefault true;

  xdg.portal = {
    enable = true;
  };
  security.rtkit.enable = true;
  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome
      noto-fonts-color-emoji
      jetbrains-mono
      sarasa-gothic
    ];
  };

  environment.systemPackages = with pkgs; [
    ocs-url
    coppwr
  ];

  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
  };
}

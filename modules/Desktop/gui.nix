{ pkgs, self, ... }:
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
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

  environment.systemPackages = with pkgs; [
    ocs-url
    coppwr
    xorg.xhost # xhost +，非常懒狗，非常不安全
  ];

  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}

{
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [ "${self}/modules/Desktop/flatpak.nix" ];

  hardware = {
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  programs.xwayland.enable = true;

  services = {
    gnome.gcr-ssh-agent.enable = true;
    power-profiles-daemon.enable = lib.mkDefault true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig = {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 4096;
          };
        };
      };
    };
    upower.enable = lib.mkDefault true;
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        tappingButtonMap = "lrm";
        scrollMethod = "twofinger";
      };
    };
  };
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    extraConfig = ''
      IdentityAgent /run/user/%i/gcr/ssh
    '';
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;
    seahorse.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };
  services = {
    gnome = {
      gnome-keyring.enable = true;
      localsearch.enable = true;
    };
    gvfs.enable = true;
    tumbler.enable = true;
  };

  security.pam.services = {
    login.enableGnomeKeyring = true;
    passwd.enableGnomeKeyring = true;
    sddm.enableGnomeKeyring = true;
    ly.enableGnomeKeyring = true;
  };

  xdg.portal = {
    enable = true;
  };
  security.rtkit.enable = true;
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      source-sans
      material-design-icons
      font-awesome
      sarasa-gothic
    ];
  };

  environment.systemPackages = with pkgs; [
    ocs-url
    coppwr
    wineWow64Packages.stagingFull
    winetricks

    brightnessctl
    ddcutil
    gnome-calculator
    gnome-characters
    gnome-font-viewer
    gnome-logs
    gnome-system-monitor
    gnome-text-editor
    kitty
    loupe
    nautilus
    pavucontrol
    playerctl
    sushi
  ];

  environment.sessionVariables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
    SSH_ASKPASS_REQUIRE = "prefer";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}

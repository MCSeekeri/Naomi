{ pkgs, ... }: {
  security.pam.services.login.u2f.enable = true;

  hardware.gpgSmartcards.enable = true;
  programs = {
    yubikey-manager.enable = true;
    yubikey-touch-detector.enable = true;
  };
  environment.systemPackages = with pkgs; [ yubioath-flutter ];
}

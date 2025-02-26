{
  services.pcscd.enable = true;
  security = {
    pam.yubico = {
      enable = true;
      debug = false;
      mode = "challenge-response";
    };
  };
  environment.systemPackages = with pkgs; [
    yubioath-flutter
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
  ];
}

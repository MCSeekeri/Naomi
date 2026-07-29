{ pkgs, ... }: {
  services = {
    pcscd.enable = true;
    yubikey-agent.enable = true;
  };

  security = {
    pam = {
      yubico = {
        # enable = true;
        debug = false;
        mode = "challenge-response";
        # id = [ "11451419" ];
        # S/N 号，不设置会有安全漏洞
      };
      services = {
        login.u2fAuth = true;
      };
    };
  };

  hardware.gpgSmartcards.enable = true;
  programs.yubikey-touch-detector.enable = true;
  environment.systemPackages = with pkgs; [
    yubioath-flutter
    yubikey-manager
  ];
}

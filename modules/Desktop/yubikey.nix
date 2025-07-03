{
  security = {
    pam = {
      yubico = {
        enable = true;
        debug = false;
        mode = "challenge-response";
        # id = [ "11451419" ]; # 务必正确设置
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
  };
  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.systemPackages = with pkgs; [
    yubioath-flutter
    yubikey-manager
    yubikey-manager-qt
  ];
}

{ pkgs, ... }:
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

  services = {
    yubikey-agent.enable = true;
  };

  hardware.gpgSmartcards.enable = true;
  boot.initrd.luks.yubikeySupport = true; # [TODO] 测试能否使用 YubiKey 解锁 LUKS，而不是模拟键盘输入密码……
  programs.yubikey-touch-detector.enable = true;
  environment.systemPackages = with pkgs; [
    yubioath-flutter
    yubikey-manager
  ];
}

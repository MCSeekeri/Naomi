{ self, ... }:
{
  imports = [ "${self}/modules/Core/avahi.nix" ];

  services = {
    system-config-printer.enable = true;
    printing = {
      enable = true;
      browsed.enable = true; # avahi 默认不启用
      cups-pdf.enable = true;
    };
  };
  hardware.sane = {
    # 需要添加用户到组 "scanner" "lp"
    enable = true;
    openFirewall = true;
  };
}

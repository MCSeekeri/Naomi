{ pkgs, ... }: {
  hardware.sane = {
    enable = true;
    openFirewall = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  services.avahi.openFirewall = true;
}

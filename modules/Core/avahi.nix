{
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
    denyInterfaces = [ "tailscale0" ];
  };
}

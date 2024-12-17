{
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = [ "--accept-routes --advertise-exit-node" ];
      openFirewall = true;
    };
  };
}
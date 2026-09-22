_: {
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
    };
  };

  environment.sessionVariables.DOCKER_HOST = "unix:///run/podman/podman.sock";
  networking.firewall.interfaces."podman*".allowedUDPPorts = [ 53 ];
}

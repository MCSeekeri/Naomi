{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true; # 用户体验不变
      defaultNetwork.settings.dns_enabled = true;
    };
    # oci-containers.containers = {
    #   hello = {
    #     image = "docker.io/library/hello-world:latest";
    #     autoStart = false;
    #     ports = [ "" ];
    #   };
    # };
    # 我之后修好这个
  };
}

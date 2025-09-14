{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.arion.nixosModules.arion ];

  virtualisation = {
    oci-containers.backend = "podman";
    containers = {
      enable = true;
      # 用大鹅而不是设置代理，能避免一些不必要的麻烦
      # containersConf.settings = {
      #   engine = {
      #     env = [
      #       "http_proxy=http://100.100.1.1:19999"
      #       "https_proxy=http://100.100.1.1:19999"
      #     ];
      #   };
      # };
    };
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true; # 用户体验不变
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = [
    pkgs.arion
    pkgs.docker-client
  ];
  virtualisation.arion = {
    backend = "podman-socket";
  };
  networking.firewall.interfaces =
    let
      matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
    in
    {
      "${matchAll}".allowedUDPPorts = [
        53
        5353
      ];
    };
}

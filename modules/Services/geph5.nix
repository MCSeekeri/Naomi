{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  environment.systemPackages = [
    pkgs.geph
    pkgs.gephgui-wry
  ];

  services.geph = {
    enable = true;
    configFile = config.sops.secrets.geph5-config.path;
  };

  systemd.services.geph = {
    serviceConfig = {
      RemoveIPC = true;
      AmbientCapabilities = lib.mkForce [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
      ];
      CapabilityBoundingSet = lib.mkForce [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_NET_BIND_SERVICE"
      ];
      SystemCallFilter = lib.mkForce [
        "@system-service"
        "@network-io"
        "ioctl"
        "socket"
        "bind"
        "connect"
      ];
    };
  };
  sops.secrets.geph5-config = {
    format = "yaml";
    key = "";
    sopsFile = "${self}/secrets/services/geph5.yaml";
  };
}

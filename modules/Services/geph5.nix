{
  config,
  pkgs,
  self,
  ...
}:
{
  environment.systemPackages = [
    pkgs.geph
    pkgs.gephgui-wry
  ];

  systemd = {
    services.geph = {
      description = "geph Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.geph}/bin/geph5-client --config /run/credentials/geph.service/config";
        Restart = "on-failure";
        RestartSec = "5s";

        Environment = [ "XDG_CONFIG_HOME=/var/cache/geph" ];
        LoadCredential = [ "config:${config.sops.secrets.geph5-config.path}" ];

        ProtectHome = true;
        PrivateTmp = true;
        ReadWritePaths = [ "/var/cache/geph" ];
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
        ];
        # RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        SystemCallFilter = [
          "@system-service"
          "@network-io"
          "ioctl"
          "socket"
          "bind"
          "connect"
        ];
        SystemCallArchitectures = "native";

        UMask = "0077";
        LimitNOFILE = 65535;
      };
    };
  };
  sops.secrets.geph5-config = {
    format = "yaml";
    key = "";
    sopsFile = "${self}/secrets/geph5.yaml";
  };
}

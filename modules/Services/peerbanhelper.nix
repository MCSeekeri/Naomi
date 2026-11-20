{ lib, ... }: {
  virtualisation.oci-containers.containers.peerbanhelper = {
    image = "docker.io/ghostchu/peerbanhelper:latest";
    labels."io.containers.autoupdate" = "registry";
    podman.sdnotify = "healthy";
    volumes = [ "pbh_data:/app/data" ];
    extraOptions = [
      "--network=host"
      "--health-cmd=${
        builtins.toJSON [
          "CMD"
          "wget"
          "-q"
          "-O"
          "/dev/null"
          "http://127.0.0.1:9898/api/metadata/manifest"
        ]
      }"
      "--health-timeout=5s"
      "--health-start-period=60s"
      "--health-on-failure=kill"
    ];
  };

  systemd.services.podman-peerbanhelper.serviceConfig.TimeoutStartSec = lib.mkForce "5min";
}

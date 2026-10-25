{ config, lib, ... }: {
  services.caddy = {
    enable = true;
    globalConfig = lib.mkBefore ''
      grace_period 10s
    '';
  };

  systemd.services.caddy = {
    serviceConfig = lib.serviceHardening {
      ReadWritePaths = lib.optional (config.services.phpfpm.pools != { }) "/run/phpfpm";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
    };
  };
}

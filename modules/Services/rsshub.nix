{ config, lib, ... }: {
  services.rsshub = {
    enable = true;
    redis = {
      enable = lib.mkDefault true;
      createLocally = lib.mkDefault true;
    };
    secretFiles = [ config.sops.secrets.rsshub_env.path ];

    settings = {
      ALLOW_USER_HOTLINK_TEMPLATE = "true";
      DEBUG_INFO = "false";
      DISALLOW_ROBOT = "true";
      LOGGER_LEVEL = "warn";
    };
  };

  systemd.services.rsshub = {
    serviceConfig = lib.serviceHardening {
      ReadWritePaths = [ "/run/redis-rsshub" ];
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
    };
  };
}

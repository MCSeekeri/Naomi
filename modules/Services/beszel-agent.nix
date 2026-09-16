{ lib, ... }: {
  services.beszel.agent = {
    enable = true;
    environment = {
      DISABLE_SSH = lib.mkDefault "true";
      EXTRA_FILESYSTEMS = lib.mkDefault "/mnt/data1,/mnt/data2";
      NICS = lib.mkDefault "-tailscale0,-podman*,-docker*,-veth*,-br-*,-dae*,-virbr*,-cni*,-ifb*,-tun*,-wg*";
      MEM_CALC = lib.mkDefault "htop";
      DISK_USAGE_CACHE = lib.mkDefault "1h";
    };
  };
}

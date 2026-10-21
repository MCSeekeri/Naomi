{ lib, ... }: {
  services.avahi = {
    enable = lib.mkDefault true;
    nssmdns4 = lib.mkDefault true;
    settings.publish = {
      disable-publishing = lib.mkDefault false;
      disable-user-service-publishing = lib.mkDefault false;
      publish-addresses = lib.mkDefault true;
      publish-domain = lib.mkDefault true;
    };
  };
}

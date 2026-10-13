_: {
  services = {
    system-config-printer.enable = true;
    printing = {
      enable = true;
      cups-pdf.enable = true;
      browsed.enable = false;
    };
    avahi.openFirewall = true;
  };
}

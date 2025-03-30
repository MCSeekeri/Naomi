{
  services = {
    system-config-printer.enable = true;
    printing = {
      enable = true;
      browsed.enable = true; # avahi 默认不启用
      cups-pdf.enable = true;
    };
  };
}

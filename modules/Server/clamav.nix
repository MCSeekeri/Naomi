{
  services.clamav = {
    updater = {
      enable = true;
    };
    daemon = {
      enable = true;
      settings = {
        MaxThreads = 16;
        MaxDirectoryRecursion = 65535;
        VirusEvent = "echo 'Virus Detected' >> /etc/motd";
      };
    };
  };
}
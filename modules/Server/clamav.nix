{
  services.clamav = {
    fangfrisch.enable = true;
    scanner = {
      enable = true;
      interval = "Mon *-*-* 01:00:00"; # 月曜日の……
    };
    updater = {
      enable = true;
    };
    daemon = {
      enable = true;
      settings = {
        MaxThreads = 16;
        MaxDirectoryRecursion = 65535;
        VirusEvent = "echo 'WARNING: Virus detected: %v' >> /etc/motd && wall 'WARNING: Virus detected: %v' ";
      };
    };
  };
}

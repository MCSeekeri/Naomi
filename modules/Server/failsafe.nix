{
  boot.initrd.systemd.suppressedUnits = [
    "emergency.service"
    "emergency.target"
  ];
  environment = {
    variables.BROWSER = "echo";
  };
  systemd = {
    enableEmergencyMode = false;
    watchdog = {
      runtimeTime = "20s";
      rebootTime = "5m";
      kexecTime = "5m";
    };
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}

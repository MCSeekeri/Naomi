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
    settings.Manager = {
      RuntimeWatchdogSec = "20s";
      RebootWatchdogSec = "5m";
      KExecWatchdogSec = "5m";
    };
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}

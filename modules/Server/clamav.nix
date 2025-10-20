{ pkgs, ... }:
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
        # https://wiki.archlinux.org/title/ClamAV#Creating_notification_popups_for_alerts
        VirusEvent = "${pkgs.writeShellScript "clamav-virus-event" ''
          ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
          for ADDRESS in /run/user/*; do
            USERID=''${ADDRESS#/run/user/}
            if [ -d "$ADDRESS" ] && [ "$USERID" -gt 0 ] 2>/dev/null; then
              /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -u critical -i dialog-warning "ClamAV Alert" "$ALERT"
            fi
          done
          echo "ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME" | ${pkgs.systemd}/bin/systemd-cat -t clamav -p warning
        ''}";
        User = "clamav";
      };
    };
  };
  security.sudo-rs = {
    execWheelOnly = false;
    extraRules = [
      {
        users = [ "clamav" ];
        commands = [
          {
            command = "${pkgs.libnotify}/bin/notify-send";
            options = [
              "NOPASSWD"
              "SETENV"
            ];
          }
        ];
      }
    ];
  };
}

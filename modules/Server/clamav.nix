{ pkgs, ... }:
{
  services.clamav = {
    # fangfrisch.enable = true; # 误报率太吓人了
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
              ${pkgs.systemd}/bin/run0 --unit "clamav-notify-$USERID.service" -u "$USERID" --setenv="DBUS_SESSION_BUS_ADDRESS=unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -u critical -i dialog-warning "ClamAV Alert" "$ALERT"
            fi
          done
          echo "ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME" | ${pkgs.systemd}/bin/systemd-cat -t clamav -p warning
        ''}";
        User = "clamav";
      };
    };
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id != "org.freedesktop.systemd1.manage-units" || subject.user != "clamav") {
        return;
      }

      var unit = action.lookup("unit");
      var verb = action.lookup("verb");
      if (verb == "start" && unit != null && unit.match(/^clamav-notify-[0-9]+\.service$/)) {
        return polkit.Result.YES;
      }
    });
  '';
}

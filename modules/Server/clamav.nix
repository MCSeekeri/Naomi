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
        VirusEvent = ''
          #!/usr/bin/env bash
          for ADDRESS in /run/user/*; do
            [ -d "$ADDRESS" ] && [ "$(${pkgs.coreutils}/bin/basename $ADDRESS)" -gt 0 ] 2>/dev/null && \
              ${pkgs.sudo-rs}/bin/sudo -u "#$(${pkgs.coreutils}/bin/basename $ADDRESS)" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -i dialog-warning "ClamAV Alert" "ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
          done
          echo "ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME" | ${pkgs.systemd}/bin/systemd-cat -t clamav -p warning'';
      };
    };
  };
}

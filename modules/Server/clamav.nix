{ pkgs, ... }:
let
  alertFile = "/run/clamav-alerts";
in
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
        VirusEvent = "${pkgs.writeShellScript "clamav-virus-event" ''
          msg="ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
          printf '%s\n' "$msg" >> ${alertFile}
          printf '%s\n' "$msg" | ${pkgs.systemd}/bin/systemd-cat -t clamav -p warning
        ''}";
      };
    };
  };

  systemd.tmpfiles.rules = [ "f ${alertFile} 0640 clamav clamav -" ];

  systemd.paths.clamav-notify = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = alertFile;
  };

  systemd.services.clamav-notify = {
    path = with pkgs; [
      coreutils
      libnotify
      util-linux
    ];
    script = ''
      [ -s ${alertFile} ] || exit 0
      latest=$(tail -n 1 ${alertFile})
      for dir in /run/user/*; do
        uid=''${dir#/run/user/}
        [ "$uid" -gt 0 ] 2>/dev/null || continue
        runuser -u "$(id -nu "$uid")" -- \
          env DBUS_SESSION_BUS_ADDRESS="unix:path=$dir/bus" \
          notify-send -u critical -i dialog-warning ClamAV "$latest" || true
      done
    '';
    serviceConfig.Type = "oneshot";
  };
}

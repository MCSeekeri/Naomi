{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  options.services.ntfy-agent.excludedUnits = lib.mkOption {
    type = with lib.types; listOf str;
    default = [
      "user@*.service"
      "NetworkManager-wait-online.service"
      "systemd-networkd-wait-online.service"
    ];
    description = "失败时不告警的单元 glob 名单";
  };

  config = {
    sops.secrets.ntfy_agent_env = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/ntfy-agent.env";
      format = "dotenv";
      key = "";
    };
    # NTFY_URL=https://ntfy.sh
    # NTFY_TOPIC=<一串又臭又长的随机内容>

    systemd.services."ntfy-alert@" = {
      description = "ntfy 告警推送";
      environment = {
        NTFY_UNIT = "%i";
        NTFY_EXCLUDED = lib.concatStringsSep " " config.services.ntfy-agent.excludedUnits;
      };
      serviceConfig.Type = "oneshot";
      serviceConfig.EnvironmentFile = [ config.sops.secrets.ntfy_agent_env.path ];
      script = ''
        for pat in $NTFY_EXCLUDED; do
          case "$NTFY_UNIT" in
            $pat) exit 0 ;;
          esac
        done

        LOGS=$(journalctl -u "$NTFY_UNIT" -n 12 --no-pager -o short-iso 2>/dev/null | tail -c 1400)
        ${lib.getExe pkgs.curl} -fsS -m 10 \
          -H "Title: $NTFY_UNIT 已失效" \
          -H "Tags: rotating_light" \
          -H "Priority: high" \
          --data-binary "$LOGS" \
          "$NTFY_URL/$NTFY_TOPIC" >/dev/null 2>&1 || true
      '';
    };

    systemd.packages = [
      (pkgs.runCommand "ntfy-agent-units" { } ''
        mkdir -p $out/lib/systemd/system/service.d
        cat > $out/lib/systemd/system/service.d/10-ntfy-agent.conf <<'EOF'
        [Unit]
        OnFailure=ntfy-alert@%n.service
        EOF
        mkdir -p "$out/lib/systemd/system/ntfy-alert@.service.d"
        ln -s /dev/null "$out/lib/systemd/system/ntfy-alert@.service.d/10-ntfy-agent.conf"
      '')
    ];
  };
}

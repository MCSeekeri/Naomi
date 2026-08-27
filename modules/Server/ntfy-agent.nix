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
      "run-*.service"
      "NetworkManager-wait-online.service"
      "systemd-networkd-wait-online.service"
      "ntfy-memguard.service"
    ];
    description = "失败时不告警的单元 glob 名单";
  };

  config = {
    sops.secrets.ntfy_agent_env = {
      sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/ntfy-agent.env";
      format = "dotenv";
      key = "";
    };
    # NTFY_SERVER=不是 ntfy.sh 的任何东西
    # NTFY_TOKEN=tk_
    # NTFY_SUFFIX=可选后缀
    # NTFY_TOPIC=topic 完全覆盖

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "ntfy-notify" ''
        set -u

        [[ $# -ge 1 ]] || {
          echo "ntfy-notify: 缺少模式参数，用法 alert <unit>|smartd|raw <title> <tags> <priority>" >&2
          exit 1
        }
        mode="$1"


        server="''${NTFY_SERVER:-https://ntfy.sh}"
        server="''${server%/}"

        auth_args=()
        if [[ -n "''${NTFY_TOKEN:-}" ]]; then
          auth_args+=(-H "Authorization: Bearer $NTFY_TOKEN")
        fi

        if [[ -n "''${NTFY_TOPIC:-}" ]]; then
          topic="$NTFY_TOPIC"
        else
          topic="''${NTFY_TOPIC_PREFIX}-''${NTFY_HOSTNAME}"
          [[ -n "''${NTFY_SUFFIX:-}" ]] && topic+="-''${NTFY_SUFFIX}"
        fi

        case "$mode" in
          alert)
            [[ $# -ge 2 ]] || { echo "ntfy-notify alert 需要单元名参数" >&2; exit 1; }
            unit="$2"
            for pat in ''${NTFY_EXCLUDED:-}; do
              case "$unit" in
                $pat) exit 0 ;;
              esac
            done
            body="$(
              ${pkgs.systemd}/bin/journalctl -u "$unit" -n 12 --no-pager -o short-iso 2>/dev/null |
                tail -c 1400
            )"
            title="$unit 已失效 [EVASION]"
            tags=rotating_light
            priority=high
            ;;
          smartd)
            body="$(
              printf '%s\n%s\n' "''${SMARTD_MESSAGE:-}" "''${SMARTD_ADDITIONALINFO:-}" |
                tail -c 1400
            )"
            title="磁盘健康异常 [ALERT]"
            tags=floppy_disk,bomb
            priority=max
            ;;
          raw)
            [[ $# -eq 4 ]] || {
              echo "ntfy-notify raw 需要 <title> <tags> <priority> 三个参数，正文走 stdin" >&2
              exit 1
            }
            title="$2"
            tags="$3"
            priority="$4"
            body="$(cat)"
            ;;
          *)
            echo "ntfy-notify: 未知模式 '$mode'" >&2
            exit 1
            ;;
        esac

        ${pkgs.curl}/bin/curl -fsS -m 10 \
          "''${auth_args[@]}" \
          -H "Title: $title" \
          -H "Tags: $tags" \
          -H "Priority: $priority" \
          --data-binary "$body" \
          -o /dev/null \
          "$server/$topic" || true
      '')
      (pkgs.writeShellScriptBin "ntfy-smartd-hook" ''
        exec /run/current-system/sw/bin/ntfy-notify smartd
      '')
      (pkgs.writeShellScriptBin "ntfy-memguard" ''
        set -u

        TRIP=50
        TRIP_N=5
        RECOVER=20
        RECOVER_N=6

        trips=0
        recovers=0
        alerted=""

        while :; do
          sleep 30

          psi="$(
            awk '/^some/ {
              for (i = 1; i <= NF; i++)
                if ($i ~ /^avg10=/) { sub("avg10=", "", $i); print $i; exit }
            }' /proc/pressure/memory 2>/dev/null
          )"
          [[ -n "$psi" ]] || continue

          if (( $(printf '%.0f' "$psi") >= TRIP )); then
            trips=$((trips + 1))
            recovers=0
          elif (( $(printf '%.0f' "$psi") < RECOVER )); then
            recovers=$((recovers + 1))
            trips=0
          fi

          if [[ -z "$alerted" ]] && (( trips >= TRIP_N )); then
            alerted=yes
            snapshot="$(
              ps -eo pmem,rss,comm --sort=-rss --no-headers 2>/dev/null |
                head -3
            )"
            printf 'PSI=%.0f%%\n%s\n' "$psi" "$snapshot" |
              /run/current-system/sw/bin/ntfy-notify raw \
                "内存压力大 [EVASION]" hourglass high
          elif [[ -n "$alerted" ]] && (( recovers >= RECOVER_N )); then
            alerted=""
            /run/current-system/sw/bin/ntfy-notify raw \
              "内存压力已恢复" sparkles default </dev/null
          fi
        done
      '')
    ];

    systemd.services."ntfy-alert@" = {
      description = "ntfy 告警推送";
      environment = {
        NTFY_TOPIC_PREFIX = "codec";
        NTFY_HOSTNAME = "%H";
        NTFY_EXCLUDED = lib.concatStringsSep " " config.services.ntfy-agent.excludedUnits;
      };
      serviceConfig.Type = "oneshot";
      serviceConfig.EnvironmentFile = [ config.sops.secrets.ntfy_agent_env.path ];
      serviceConfig.ExecStart = "/run/current-system/sw/bin/ntfy-notify alert %i";
    };

    systemd.services.ntfy-memguard = {
      description = "ntfy 内存压力守卫";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.NTFY_TOPIC_PREFIX = "codec";
      environment.NTFY_HOSTNAME = "%H";
      serviceConfig.Type = "simple";
      serviceConfig.EnvironmentFile = [ config.sops.secrets.ntfy_agent_env.path ];
      serviceConfig.ExecStart = "/run/current-system/sw/bin/ntfy-memguard";
      serviceConfig.Restart = "on-failure";
    };

    services.smartd = {
      autodetect = true;
      notifications.mail.enable = lib.mkDefault false;
      notifications.wall.enable = lib.mkDefault false;
      notifications.x11.enable = lib.mkDefault false;
      defaults.monitored = "-a -m <nomailer> -M exec /run/current-system/sw/bin/ntfy-smartd-hook";
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

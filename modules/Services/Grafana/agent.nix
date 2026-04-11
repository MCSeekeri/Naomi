{ config, ... }:
{
  # 客户端
  # environment.etc."alloy/sink.alloy".text = ''
  #   loki.write "default" {
  #     endpoint {
  #       url = "http://{地址}:9092/loki/api/v1/push"
  #     }
  #   }
  # '';

  assertions = [
    {
      assertion = config.environment.etc ? "alloy/sink.alloy";
      message = ''
        导入 Grafana agent 模块时，必须在主机配置中提供
        environment.etc."alloy/sink.alloy".text
        以定义 loki.write.default 的上游地址，例如：
        http://聚合端可达地址:9092/loki/api/v1/push
      '';
    }
  ];

  services = {
    alloy = {
      enable = true;
      extraFlags = [
        "--disable-reporting"
        "--feature.component-shutdown-deadline=15s"
      ];
    };
    prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [
        "systemd"
        "processes"
      ];
      port = 9091;
    };
  };

  environment.etc."alloy/source-journal.alloy".text = ''
    logging {
      format = "logfmt"
      level = "warn"
    }

    loki.relabel "journal" {
      forward_to = [loki.write.default.receiver]

      rule {
        replacement = "${config.networking.hostName}"
        target_label = "host"
      }

      rule {
        replacement = "journald"
        target_label = "source"
      }

      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label = "unit"
      }

      rule {
        source_labels = ["__journal_priority_keyword"]
        target_label = "priority"
      }

      rule {
        source_labels = ["__journal__transport"]
        target_label = "transport"
      }

      rule {
        source_labels = ["__journal__syslog_identifier"]
        target_label = "syslog_identifier"
      }
    }

    loki.source.journal "read" {
      forward_to = [loki.write.default.receiver]
      relabel_rules = loki.relabel.journal.rules
      max_age = "24h"
    }
  '';

  systemd.services.alloy.serviceConfig = {
    SupplementaryGroups = [
      "systemd-journal"
      "adm"
    ];
    TimeoutStopSec = "20s";
  };
}

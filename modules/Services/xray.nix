{ config, self, ... }:
{
  services.xray = {
    enable = true;
    settingsFile = config.sops.templates."xray-${config.networking.hostName}-config.json".path;
  };

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.core.netdev_max_backlog" = 16384;
    "net.core.rmem_max" = 67108864;
    "net.core.somaxconn" = 8192;
    "net.core.wmem_max" = 67108864;
    "net.ipv4.ip_local_port_range" = "10240 65535";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_mtu_probing" = 1;
    "net.ipv4.tcp_notsent_lowat" = 16384;
    "net.ipv4.tcp_rmem" = "4096 262144 67108864";
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_wmem" = "4096 262144 67108864";
  };

  sops = {
    secrets = {
      "xray-${config.networking.hostName}-uuid" = {
        restartUnits = [ "xray.service" ];
        sopsFile = "${self}/secrets/services/xray.yaml";
      };
      "xray-${config.networking.hostName}-vless-decryption" = {
        restartUnits = [ "xray.service" ];
        sopsFile = "${self}/secrets/services/xray.yaml";
      };
    };
  };

  systemd.services.xray = {
    after = [ "sops-install-secrets.service" ];
    requires = [ "sops-install-secrets.service" ];
    serviceConfig = {
      DevicePolicy = "closed";
      KeyringMode = "private";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      Restart = "on-failure";
      RestartSec = "5s";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@clock"
        "~@cpu-emulation"
        "~@debug"
        "~@module"
        "~@mount"
        "~@obsolete"
        "~@privileged"
        "~@raw-io"
        "~@reboot"
        "~@resources"
        "~@swap"
        "~_sysctl"
        "~acct"
        "~add_key"
        "~bpf"
        "~fanotify_init"
        "~finit_module"
        "~init_module"
        "~ioperm"
        "~iopl"
        "~kcmp"
        "~keyctl"
        "~lookup_dcookie"
        "~mbind"
        "~migrate_pages"
        "~move_pages"
        "~name_to_handle_at"
        "~nfsservctl"
        "~open_by_handle_at"
        "~perf_event_open"
        "~personality"
        "~process_madvise"
        "~process_vm_readv"
        "~process_vm_writev"
        "~ptrace"
        "~quotactl"
        "~quotactl_fd"
        "~request_key"
        "~set_mempolicy"
        "~setns"
        "~swapon"
        "~swapoff"
        "~sysfs"
        "~userfaultfd"
        "~uselib"
        "~vm86"
        "~vm86old"
      ];
      SystemCallArchitectures = "native";
      UMask = "0077";
    };
  };
}

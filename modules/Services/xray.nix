{
  config,
  pkgs,
  self,
  ...
}:
{
  services.xray = {
    enable = true;
    package = pkgs.xray.overrideAttrs (_: {
      version = "26.4.25";
      src = pkgs.fetchFromGitHub {
        owner = "XTLS";
        repo = "Xray-core";
        rev = "v26.4.25";
        hash = "sha256-sJWL6Z6bMUrL0u2Dd77/bCQbgynNOBN/Vh4RybFABS0=";
      };
      vendorHash = "sha256-D7zOXdiMr5g0drvwqxD8CoqAVsFyR70sW7mJnsVAEWE=";
    });
    settingsFile = config.sops.templates."xray-${config.networking.hostName}-config.json".path;
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

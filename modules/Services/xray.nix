{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  services.xray = {
    enable = true;
    package =
      (pkgs.xray.override { buildGo126Module = pkgs.buildGo127Module; }).overrideAttrs
        (old: rec {
          version = "26.9.9";
          src = pkgs.fetchFromGitHub {
            owner = "XTLS";
            repo = "Xray-core";
            rev = "v${version}";
            hash = "sha256-GqPEAgWM9Wx19uxMj0LGeOyHreLbU0IMSmalwLe/SIc=";
          };
          vendorHash = "sha256-6Qa05hFdvfLlH8WQd426IU7MScmeevIgrgP5037pNek=";
          preBuild = (old.preBuild or "") + ''
            export GOFLAGS="$GOFLAGS -gcflags=all=-l=4"
          '';
        });
    settingsFile = config.sops.templates."xray-${config.networking.hostName}-config.json".path;
  };

  sops = {
    secrets = {
      "xray-uuid" = {
        restartUnits = [ "xray.service" ];
        sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/xray.yaml";
      };
      "xray-vless-decryption" = {
        restartUnits = [ "xray.service" ];
        sopsFile = "${self}/secrets/hosts/${config.networking.hostName}/xray.yaml";
      };
    };
  };

  systemd.services.xray = {
    after = [ "sops-install-secrets.service" ];
    requires = [ "sops-install-secrets.service" ];
    serviceConfig = lib.hardenedServiceConfig // {
      DevicePolicy = "closed";
      KeyringMode = "private";
      MemoryDenyWriteExecute = true;
      Restart = "on-failure";
      RestartSec = "5s";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
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
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (lib.isServer config) {
  boot = {
    kernelModules = [ "softdog" ];
    kernelParams = [ "boot.panic_on_fail" ];
    kernel.sysctl = {
      "kernel.panic_on_oops" = 1;
      "kernel.softlockup_panic" = 1;
      "kernel.hardlockup_panic" = 1;
    };

    initrd = {
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
      ];

      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          ignoreEmptyHostKeys = true;
          authorizedKeys = lib.unique (
            lib.concatLists (lib.mapAttrsToList (_: u: u.openssh.authorizedKeys.keys) config.users.users)
          );
        };
      };

      systemd = {
        extraBin.ssh-keygen = "${pkgs.openssh}/bin/ssh-keygen";

        services.initrd-ssh-keygen = {
          description = "Generate SSH host key for initrd";
          before = [ "sshd.service" ];
          requiredBy = [ "sshd.service" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            ExecStart = ''/bin/ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key'';
          };
        };
      };
    };
  };

  systemd = {
    enableEmergencyMode = false;
    settings.Manager = {
      RuntimeWatchdogSec = "20s";
      RebootWatchdogSec = "5m";
      KExecWatchdogSec = "5m";
    };
  };
}

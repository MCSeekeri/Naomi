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
    package = pkgs.xray.overrideAttrs (_old: {
      version = "26.10.17";
      src = pkgs.fetchFromGitHub {
        owner = "XTLS";
        repo = "Xray-core";
        rev = "v26.10.17";
        hash = "sha256-MUeF3LwZ8bN7gEQCDdzgZKg+agYIokxfQ81VWIkXUgY=";
      };
      vendorHash = "sha256-x7aVga0J8tgzvbUxfy9KQKk6CN/LgM29e6F4My56QxI=";
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
    serviceConfig = lib.mkMerge [
      lib.hardenedServiceConfig
      {
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
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@raw-io"
          "~@swap"
          "~kcmp"
          "~name_to_handle_at"
          "~personality"
          "~userfaultfd"
        ];
      }
    ];
  };
}

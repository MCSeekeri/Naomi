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

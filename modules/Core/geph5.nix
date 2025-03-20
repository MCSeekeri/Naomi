{
  config,
  pkgs,
  lib,
  ...
}:
let
  geph5-client = pkgs.callPackage ../../pkgs/geph5-client { };
in
{

  systemd = {
    tmpfiles.rules = [ "d /root/.config 0755 root root" ];
    services.geph5-client = {
      description = "geph5-client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        TimeoutStartSec = 0;
        Type = "simple";
        ExecStart = "${geph5-client}/bin/geph5-client --config ${config.sops.secrets.geph5-config.path}";
        Restart = "on-failure";
        RestartSec = "5s";
        LimitNOFILE = 65535;
      };
    };
  };
  sops.secrets.geph5-config = {
    format = "yaml";
    key = "";
    sopsFile = ../../secrets/geph5.yaml;
  };
}

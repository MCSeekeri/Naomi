{
  config,
  pkgs,
  self,
  ...
}:
{
  systemd = {
    tmpfiles.rules = [ "d /root/.config 0755 root root" ];
    services.geph = {
      description = "geph";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        TimeoutStartSec = 0;
        Type = "simple";
        ExecStart = "${pkgs.geph}/bin/geph5-client --config ${config.sops.secrets.geph5-config.path}";
        Restart = "on-failure";
        RestartSec = "5s";
        LimitNOFILE = 65535;
      };
    };
  };
  sops.secrets.geph5-config = {
    format = "yaml";
    key = "";
    sopsFile = "${self}/secrets/geph5.yaml";
  };
}

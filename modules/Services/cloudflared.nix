{ config, self, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${config.networking.hostName}" = {
        credentialsFile = config.sops.secrets."cloudflare-tunnel-${config.networking.hostName}".path;
        default = "http_status:404";
      };
    };
  };
  # 虽然虽然官方仪表板配置的方式不那么"Nix 风味"，但是我个人认为隧道这种配置最好还是能够随时调整，适应不同情况。
  # 记得在启动之后迁移隧道，理论上不会影响现有功能。

  # [TODO] 25.05 版本使用动态用户，不再固定为 cloudflared，需要测试

  sops.secrets."cloudflare-tunnel-${config.networking.hostName}" = {
    sopsFile = "${self}/secrets/services/cloudflare.yaml";
  };
}

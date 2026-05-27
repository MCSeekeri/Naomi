{ lib, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-bzMqxWTqrJ1skZmRTXyEMCKStXpljbqe5r0Ve2cnBfM="; # 怎么还有版本不变哈希变动的，确定性部署不存在了？
    };
    globalConfig = lib.mkBefore ''
      grace_period 10s
    '';
  };
}

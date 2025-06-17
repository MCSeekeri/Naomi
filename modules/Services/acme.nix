{ lib, ... }:
{
  services = {
    acme-dns = {
      enable = true;
    };
  };
  security.acme = {
    acceptTerms = true; # 用户协议是个谎言
    defaults = {
      email = lib.mkDefault "mcseekeri@outlook.com";
      dnsProvider = lib.mkDefault "cloudflare";
      # [WARN] 自用的时候务必确保修改了这两个字段，免得把证书签我名下
    };
  };
}

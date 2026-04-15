{ lib, pkgs, ... }:
{
  services.dae = {
    enable = true;
    package = lib.mkDefault (
      pkgs.dae.overrideAttrs {
        # https://github.com/daeuniverse/flake.nix/blob/main/metadata.json
        version = "unstable-2026-02-20.030902f";
        src = pkgs.fetchFromGitHub {
          owner = "daeuniverse";
          repo = "dae";
          rev = "030902f519f5b63f839327fd2fa9d8f906f4c504";
          hash = "sha256-wIka/hzF2MzLebrgUHOB+BaRIEx4cD3TXPV9uqP9m7U=";
          fetchSubmodules = true;
        };
        vendorHash = "sha256-MJVmAg+xyS53295FZ5HYB4rfbWHjUFBkxIOBxqxQP3U=";
      }
    );
    assets = with pkgs; [
      v2ray-geoip
      v2ray-domain-list-community
      sing-geoip
      sing-geosite
    ];
    config = lib.mkDefault (builtins.readFile ./config.dae);
  };

  networking = {
    nameservers = lib.mkForce [ "127.0.0.1" ];
    # 不幸的是，有些时候需要手动配置 NetworkManager 的 DNS 防止泄露
    networkmanager.dns = lib.mkForce "none";
  };
}

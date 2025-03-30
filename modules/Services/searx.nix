{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;
    uwsgiConfig = {
      # https://github.com/NixOS/nixpkgs/issues/292652
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
    };
    redisCreateLocally = true; # Valkey?
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 56;
      };
      botdetection = {
        ip_limit = {
          filter_link_local = true;
          link_token = true;
        };
      };
    };
    settings = {
      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "bing".disabled = false;
        "qwant".disabled = true;
        "ddg definitions".disabled = false;
        "wikibooks".disabled = false;
        "wikidata".disabled = false;
        "bing images".disabled = false;
        "google images".disabled = false;
        "artic".disabled = false;
        "deviantart".disabled = false;
        "openverse".disabled = false;
        "unsplash".disabled = false;
        "wallhaven".disabled = false;
        "wikicommons.images".disabled = false;
        "peertube".disabled = false;
        "sepiasearch".disabled = false;
        "youtube".disabled = false;
        "nixos wiki".disabled = false;
        "nyaa".disabled = false;
      };

      server = {
        secret_key = "$(cat ${config.sops.secrets.secret_key.path})";
        limiter = true;
        image_proxy = true;
      };

      ui = {
        static_use_hash = true;
        default_locale = "zh-Hans-CN";
        results_on_new_tab = true;
      };

      search = {
        languages = [
          "zh"
          "zh-CN"
          "en"
          "en-US"
        ];
        formats = [
          "html"
          "json" # 大模型
        ];
      };
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [
    (lib.head config.services.nginx.virtualHosts."SearXNG".listen).port
  ];
  users.groups.searx.members = [ "nginx" ];
  services.nginx = {
    enable = true;
    virtualHosts = {
      "SearXNG" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 7327;
          }
        ];
        locations = {
          "/" = {
            extraConfig = ''
              uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};
            '';
          };
        };
      };
    };
  };

  sops.secrets.secret_key = {
    sopsFile = "${self}/secrets/services/searx.yaml";
  };
}

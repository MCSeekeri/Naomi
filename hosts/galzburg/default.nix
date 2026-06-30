{
  config,
  lib,
  pkgs,
  self,
  modulesPath,
  ...
}:
{
  imports = [
    ./disko-config.nix
    (modulesPath + "/profiles/qemu-guest.nix")

    "${self}/modules/Core"
    "${self}/modules/Hardware"

    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Server/podman.nix"

    "${self}/modules/Services/archisteamfarm.nix"
    "${self}/modules/Services/cloudflared.nix"
    "${self}/modules/Services/cowrie.nix"
    "${self}/modules/Services/Grafana"
    "${self}/modules/Services/Grafana/agent.nix"
    "${self}/modules/Services/caddy.nix"
    "${self}/modules/Services/niks3.nix"
    "${self}/modules/Services/openlist.nix"
    "${self}/modules/Services/privatebin.nix"
    "${self}/modules/Services/vaultwarden.nix"
    "${self}/modules/Services/xray.nix"

    "${self}/users/remote"
  ];

  networking = {
    hostName = "galzburg";
    firewall = {
      allowedTCPPorts = [
        22 # 兵者，诡道也。
        23
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
      interfaces.tailscale0.allowedTCPPorts = [
        9090
        9092
      ];
      logRefusedConnections = false;
    };
  };

  hardware = {
    cpu.type = "qemu";
    deviceType = "server";
    enableAllFirmware = false;
  };

  boot = {
    kernel.sysctl = {
      "net.core.netdev_max_backlog" = lib.mkForce 32768;
      "net.core.optmem_max" = lib.mkForce 131072;
      "net.core.rmem_max" = lib.mkForce 134217728;
      "net.core.somaxconn" = lib.mkForce 16384;
      "net.core.wmem_max" = lib.mkForce 134217728;
      "fs.file-max" = 2097152;
      "net.ipv4.tcp_max_syn_backlog" = 16384;
      "net.ipv4.udp_rmem_min" = lib.mkForce 32768;
      "net.ipv4.udp_wmem_min" = lib.mkForce 32768;
      "net.ipv4.tcp_rmem" = lib.mkForce "4096 262144 134217728";
      "net.ipv4.tcp_wmem" = lib.mkForce "4096 262144 134217728";
      "net.netfilter.nf_conntrack_max" = 262144;
    };
    loader = {
      grub = {
        enable = true;
      };
      limine = {
        enable = false;
      };
    };
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sr_mod"
      "virtio_blk"
    ];
    kernelModules = [ "kvm-amd" ];
  };

  nix = {
    gc = {
      options = "--delete-older-than 2d";
    };
    buildMachines = [
      {
        hostName = "ThinkStation2";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 128;
        speedFactor = 16;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
          "gccarch-x86-64-v4"
          "gccarch-x86-64-v3"
          "gccarch-x86-64-v2"
        ];
      }
    ];
  };

  system = {
    stateVersion = "26.05";
  };

  sops.secrets = {
    masterKey.sopsFile = "${self}/secrets/hosts/galzburg/meilisearch.yaml";
    openlist_env = {
      sopsFile = "${self}/secrets/hosts/galzburg/openlist.env";
      format = "dotenv";
      owner = "openlist";
      group = "openlist";
      mode = "0440";
      key = "";
    };
    acme = {
      sopsFile = "${self}/secrets/hosts/galzburg/acme.env";
      format = "dotenv";
      key = "";
    };
    vaultwarden_env = {
      sopsFile = "${self}/secrets/hosts/galzburg/vaultwarden.env";
      format = "dotenv";
      key = "";
      owner = "vaultwarden";
      group = "vaultwarden";
      mode = "0440";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "mcseekeri@outlook.com";
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets.acme.path;
    };
  };

  sops.templates."xray-${config.networking.hostName}-config.json" = {
    content = builtins.toJSON {
      log = {
        access = "none";
        loglevel = "warning";
        maskAddress = "half";
      };
      inbounds = [
        {
          tag = "vless-xhttp";
          listen = "127.0.0.1";
          port = 30101;
          protocol = "vless";
          settings = {
            clients = [
              {
                id = config.sops.placeholder."xray-uuid";
                email = "galzburg@xhttp";
                flow = "xtls-rprx-vision";
              }
            ];
            decryption = config.sops.placeholder."xray-vless-decryption";
          };
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
              "quic"
            ];
            routeOnly = true;
          };
          streamSettings = {
            sockopt = {
              trustedXForwardedFor = [ "127.0.0.1" ];
            };
            network = "xhttp";
            xhttpSettings = {
              path = "/static";
              xPaddingObfsMode = true;
              xPaddingMethod = "tokenish";
              xPaddingPlacement = "queryInHeader";
              xPaddingHeader = "X-Signature";
              xPaddingKey = "sig";
              sessionPlacement = "query";
              sessionKey = "id";
              seqPlacement = "query";
              seqKey = "part";
            };
          };
        }
      ];
      routing = {
        domainStrategy = "IPIfNonMatch";
        rules = [
          {
            # 容易被大公司用 DMCA 击落
            type = "field";
            protocol = [ "bittorrent" ];
            outboundTag = "block";
          }
          {
            type = "field";
            domain = [ "geosite:private" ];
            outboundTag = "block";
          }
          {
            type = "field";
            ip = [ "geoip:private" ];
            outboundTag = "block";
          }
          {
            type = "field";
            ip = [ "geoip:cn" ];
            outboundTag = "block";
          }
        ];
      };
      outbounds = [
        {
          protocol = "freedom";
          tag = "direct";
        }
        {
          protocol = "blackhole";
          tag = "block";
        }
      ];
    };
    restartUnits = [ "xray.service" ];
  };

  services = {
    # 单车单车，异乡的温柔
    openssh.ports = [ 16489 ];
    # 偷车偷车，像江水东流

    journald.extraConfig = ''
      SystemMaxUse=64M
      SystemMaxFileSize=8M
      SystemMaxFiles=8
      MaxRetentionSec=14day
      RateLimitIntervalSec=30s
      RateLimitBurst=2000
    '';

    fail2ban = {
      maxretry = lib.mkForce 3;
      bantime = "12h";
      bantime-increment = {
        enable = true;
        maxtime = "7d";
      };
    };

    nginx.enable = lib.mkForce false;
    openlist = {
      enable = true;
      instances = {
        openlist = {
          domain = "pan.mcseekeri.com";
          port = 25478;
          caddyExtraConfig = ''
            handle /static* {
              reverse_proxy h2c://127.0.0.1:30101 {
                flush_interval -1
                stream_close_delay 5m
              }
            }
          '';
        };
        openlist-sciadv = {
          domain = "drive.sci-adv.org";
          port = 25479;
          dbTablePrefix = "openlist_sciadv_";
          meilisearchIndex = "openlist_sciadv";
        };
      };
    };

    grafana.settings = {
      security.admin_user = "MCSeekeri";
      server = {
        domain = "grafana.mcseekeri.com";
        root_url = "https://grafana.mcseekeri.com/";
      };
    };

    sillytavern = {
      enable = true;
      package = pkgs.nur.repos.MCSeekeri.luker;
      configFile = "/var/lib/SillyTavern/sillytavern.yaml";
    };

    privatebin.group = "caddy";

    # H2 限速多，H3 多限速
    # QUIC 和 IPv6 全面普及的世界，你在哪……

    caddy = {
      globalConfig = ''
        servers {
          trusted_proxies static 127.0.0.1/8 ::1 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22 2400:cb00::/32 2606:4700::/32 2803:f800::/32 2405:b500::/32 2405:8100::/32 2a06:98c0::/29 2c0f:f248::/32
          trusted_proxies_strict
          client_ip_headers CF-Connecting-IP X-Forwarded-For
        }
      '';
      virtualHosts =
        lib.mapAttrs
          (
            name: v:
            v
            // {
              useACMEHost = name;
              logFormat = lib.mkForce "output discard";
            }
          )
          {
            "grafana.mcseekeri.com" = {
              extraConfig = ''
                encode zstd gzip

                reverse_proxy 127.0.0.1:4300
              '';
            };
            "niks3.mcseekeri.com" = {
              extraConfig = ''
                reverse_proxy 127.0.0.1:5751
              '';
            };
            "paste.mcseekeri.com" = {
              extraConfig = ''
                encode zstd gzip

                root * ${config.services.privatebin.package}
                file_server
                php_fastcgi unix/${config.services.phpfpm.pools.privatebin.socket}
              '';
            };
            "vault.mcseekeri.com" = {
              extraConfig = ''
                encode zstd gzip

                reverse_proxy 127.0.0.1:8222
              '';
            };
            "st.mcseekeri.com" = {
              extraConfig = ''
                encode zstd gzip

                reverse_proxy 127.0.0.1:25480
              '';
            };
            "ea-app.mcseekeri.com" = {
              extraConfig = ''
                handle /static* {
                  reverse_proxy h2c://127.0.0.1:30101 {
                    flush_interval -1
                    stream_close_delay 5m
                  }
                }

                handle {
                  respond "Not Found" 404
                }
              '';
            };
          };
    };

    vaultwarden = {
      configureNginx = lib.mkForce false;
      domain = "vault.mcseekeri.com";
      environmentFile = [ config.sops.secrets.vaultwarden_env.path ];
      config = {
        ENABLE_WEBSOCKET = true;
        ROCKET_ADDRESS = "127.0.0.1";
      };
    };

    prometheus.scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            labels.host = "galzburg";
            targets = [ "127.0.0.1:9091" ];
          }
          {
            labels.host = "cyprus";
            targets = [ "cyprus:9091" ];
          }
        ];
      }
      {
        job_name = "cowrie";
        static_configs = [
          {
            labels.host = "galzburg";
            targets = [ "127.0.0.1:9000" ];
          }
        ];
      }
    ];
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    avahi.enable = false;
    niks3 = {
      httpAddr = "127.0.0.1:5751";
      cacheUrl = "https://nix.mcseekeri.com";
      s3 = {
        endpoint = "e948fb59c8aa2a756017549554f66d6a.r2.cloudflarestorage.com";
        bucket = "nix";
      };
      oidc.providers.github = {
        issuer = "https://token.actions.githubusercontent.com";
        audience = "https://niks3.mcseekeri.com";
        boundClaims = {
          repository_owner = [ "MCSeekeri" ];
          event_name = [
            "push"
            "workflow_dispatch"
          ];
        };
      };
    };
  };

  systemd = {
    settings.Manager.DefaultLimitNOFILE = "1048576";
    services.tailscaled.serviceConfig.LogLevelMax = "notice";
  };

  environment = {
    etc."alloy/sink.alloy".text = ''
      loki.write "default" {
        endpoint {
          url = "http://127.0.0.1:9092/loki/api/v1/push"
        }
      }
    '';
  };
}

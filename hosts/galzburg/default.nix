{
  config,
  lib,
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
    "${self}/modules/Services/openlist.nix"
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
    masterKey.sopsFile = "${self}/secrets/services/meilisearch.yaml";
    openlist_env = {
      sopsFile = "${self}/secrets/services/openlist.env";
      format = "dotenv";
      owner = "openlist";
      group = "openlist";
      mode = "0440";
      key = "";
    };
    acme = {
      sopsFile = "${self}/secrets/services/acme.env";
      format = "dotenv";
      key = "";
    };
    vaultwarden_env = {
      sopsFile = "${self}/secrets/services/vaultwarden.env";
      format = "dotenv";
      key = "";
      owner = "vaultwarden";
      group = "vaultwarden";
      mode = "0440";
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
                id = config.sops.placeholder."xray-${config.networking.hostName}-uuid";
                email = "galzburg@xhttp";
                flow = "xtls-rprx-vision";
              }
            ];
            decryption = config.sops.placeholder."xray-${config.networking.hostName}-vless-decryption";
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

    # H2 限速多，H3 多限速
    # QUIC 和 IPv6 全面普及的世界，你在哪……

    caddy = {
      email = "mcseekeri@outlook.com";
      environmentFile = config.sops.secrets.acme.path;
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}

        ech ech.mcseekeri.com {
          dns cloudflare {env.CLOUDFLARE_DNS_API_TOKEN}
        }
      '';
      virtualHosts = lib.mapAttrs (_: v: v // { logFormat = lib.mkForce "output discard"; }) {
        "ech.mcseekeri.com" = {
          extraConfig = ''
            respond "" 204
          '';
        };
        "pan.mcseekeri.com" = {
          extraConfig = ''
            encode zstd gzip

            handle /static* {
              reverse_proxy h2c://127.0.0.1:30101 {
                flush_interval -1
                stream_close_delay 5m
              }
            }

            handle {
              reverse_proxy 127.0.0.1:25478
            }
          '';
        };
        "drive.sci-adv.org" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy 127.0.0.1:25479
          '';
        };
        "grafana.mcseekeri.com" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy 127.0.0.1:4300
          '';
        };
        "vault.mcseekeri.com" = {
          extraConfig = ''
            encode zstd gzip

            reverse_proxy 127.0.0.1:8222
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

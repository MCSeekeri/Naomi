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
    "${self}/modules/Services/openlist.nix"
    "${self}/modules/Services/nginx.nix"
    "${self}/modules/Services/xray.nix"

    "${self}/users/remote"
  ];

  networking = {
    hostName = "galzburg";
    firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
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
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
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
        mandatoryFeatures = [ ];
      }
    ];
  };

  system = {
    stateVersion = "25.11";
    autoUpgrade.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "mcseekeri@outlook.com";
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets.acme.path;
    };
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
  };

  sops.templates."xray-${config.networking.hostName}-config.json" = {
    content = builtins.toJSON {
      log = {
        loglevel = "warning";
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
          streamSettings = {
            network = "xhttp";
            xhttpSettings = {
              path = "/static";
            };
          };
        }
      ];
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

    openlist = {
      enable = true;
      instances = {
        openlist = {
          domain = "pan.mcseekeri.com";
          port = 25478;
        };
        openlist-sciadv = {
          domain = "drive.sci-adv.cc";
          port = 25479;
          dbTablePrefix = "openlist_sciadv_";
          meilisearchIndex = "openlist_sciadv";
        };
      };
    };

    # vless://{UUID}@pan.mcseekeri.com:443?encryption={ENCRYPTION}&flow=xtls-rprx-vision&security=tls&sni=pan.mcseekeri.com&alpn=h2&fp=chrome&type=xhttp&host=pan.mcseekeri.com&path=%2Fstatic#galzburg-h2
    # vless://{UUID}@pan.mcseekeri.com:443?encryption={ENCRYPTION}&flow=xtls-rprx-vision&security=tls&sni=pan.mcseekeri.com&alpn=h3&fp=chrome&type=xhttp&mode=packet-up&host=pan.mcseekeri.com&path=%2Fstatic#galzburg-h3
    # H2 限速多，H3 多限速
    # QUIC 和 IPv6 全面普及的世界，你在哪……

    nginx = {
      appendConfig = ''
        worker_processes auto;
        worker_rlimit_nofile 131072;
      '';
      appendHttpConfig = ''
        keepalive_requests 1000;
        open_file_cache max=200000 inactive=20s;
        open_file_cache_valid 30s;
        open_file_cache_min_uses 2;
        open_file_cache_errors on;
      '';
      eventsConfig = ''
        worker_connections 8192;
        use epoll;
      '';
      upstreams.xray-xhttp = {
        servers."127.0.0.1:30101" = { };
        extraConfig = ''
          keepalive 32;
        '';
      };
      virtualHosts."pan.mcseekeri.com" = {
        http2 = true;
        http3 = true;
        quic = true;
        reuseport = true;
        extraConfig = ''
          add_header Alt-Svc 'h3=":443"; ma=86400' always;
          add_header Strict-Transport-Security "max-age=31536000" always;
        '';
        locations."^~ /static" = {
          extraConfig = ''
            access_log off;
            log_not_found off;

            grpc_pass grpc://xray-xhttp;
            client_body_timeout 1d;
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
            client_max_body_size 0;

            grpc_set_header Host $host;
            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            grpc_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
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
}

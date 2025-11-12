{ config, lib, ... }:
{
  networks = {
    home = {
      name = "Home";
      cidrv4 = "192.168.1.0/24";
    };

    lab = {
      name = "Lab";
      cidrv4 = "192.168.1.0/24";
    };

    tailscale = {
      name = "tailscale";
      cidrv4 = "100.64.0.0/10";
    };
  };

  nodes = {
    internet = config.lib.topology.mkInternet {
      hardware.image = lib.themes.icons.map.abstract.cloud;
      connections = with config.lib.topology; [
        (mkConnection "ax3600" "wan")
        (mkConnection "ikuai" "wan")
      ];
    };

    cyprus = {
      deviceType = "nixos";
      interfaces = {
        tailscale0 = {
          network = "tailscale";
          addresses = [ "100.100.1.1" ];
          virtual = true;
        };
        wlp0s20f3 = {
          network = "lab";
        };
      };
    };

    manhattan = {
      deviceType = "nixos";
      guestType = "microvm";
      parent = "cyprus";
      interfaces = {
        enp0s3 = {
          network = "lab";
          icon = "interfaces.ethernet";
        };
        tailscale0 = {
          network = "tailscale";
          addresses = [ "100.100.20.1" ];
          virtual = true;
        };
      };
    };

    costarica = {
      deviceType = "nixos";
      interfaces = {
        eno1 = {
          network = "home";
        };
        tailscale0 = {
          network = "tailscale";
          addresses = [ "100.100.20.1" ];
          virtual = true;
        };
      };
    };

    seychelles = {
      deviceType = "nixos";
      interfaces = {
        eno2 = {
          network = "lab";
          type = "wired";
          icon = "interfaces.ethernet";
        };
        tailscale0 = {
          network = "tailscale";
          addresses = [ "100.100.2.2" ];
          virtual = true;
        };
      };
    };

    ax3600 = {
      deviceType = "router";
      interfaces = {
        wan = {
          type = "wired";
          icon = "interfaces.ethernet";
        };
        lan.physicalConnections = with config.lib.topology; [
          (mkConnection "cyprus" "wlp0s20f3")
          (mkConnection "manhattan" "enp0s3")
          (mkConnection "seychelles" "eno2")
        ];
      };
    };

    ikuai = {
      deviceType = "switch";
      interfaces = {
        wan = {
          type = "wired";
          icon = "interfaces.ethernet";
        };
        lan.physicalConnections = with config.lib.topology; [ (mkConnection "costarica" "eno1") ];
      };
    };
  };
}

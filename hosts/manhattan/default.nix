{
  lib,
  self,
  modulesPath,
  ...
}:
{
  imports = [
    ./disko-config.nix
    "${modulesPath}/profiles/qemu-guest.nix"

    "${self}/modules/Core"
    "${self}/modules/Hardware"

    "${self}/modules/Server/firewall.nix"
    "${self}/modules/Server/clamav.nix"
    "${self}/modules/Server/failsafe.nix"
    "${self}/modules/Server/virt/libvirt.nix"
    "${self}/modules/Desktop/plasma.nix"
    "${self}/modules/Desktop/sunshine.nix"
    "${self}/modules/Desktop/programs.nix"
    "${self}/modules/Desktop/gaming.nix"
    "${self}/modules/Desktop/fcitx5.nix"
    # "${self}/modules/Desktop/clash.nix" # CVE
    "${self}/modules/Desktop/adb.nix"
    "${self}/modules/Desktop/cups.nix"
    "${self}/modules/Desktop/hyprland.nix"

    "${self}/modules/Services/cockpit.nix"
    "${self}/modules/Services/uptime-kuma.nix"
    "${self}/modules/Services/cloudflared.nix"
    "${self}/modules/Services/ollama.nix"
    "${self}/modules/Services/searx.nix"
    "${self}/modules/Services/archisteamfarm.nix"
    # "${self}/modules/Services/privatebin.nix"
    "${self}/modules/Services/misskey.nix"
    "${self}/modules/Services/glances.nix"

    "${self}/modules/Games/retro.nix"

    "${self}/modules/Containers/peerbanhelper.nix"

    "${self}/users/mcseekeri"
    "${self}/users/mihomo"
  ];

  # 网络配置
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "manhattan"; # 主机名，设置好之后最好不要修改
  };
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    cpu.type = "qemu";
  };

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "xhci_pci"
      "ahci"
      "sr_mod"
    ];
    kernelModules = [ "kvm-intel" ];
  };
  system = {
    stateVersion = "24.11";
    autoUpgrade.enable = true;
  };

  services.misskey = {
    reverseProxy = {
      enable = true;
      host = "mcseekeri.com";
      ssl = false;
      webserver.nginx = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 6477;
          }
        ];
        locations = {
          "misskey" = {
            proxyPass = "http://localhost:3000";
            recommendedProxySettings = true;
          };
        };
      };
    };
    settings = {
      url = "https://mcseekeri.com";
      id = "aidx";
    };
  };
}

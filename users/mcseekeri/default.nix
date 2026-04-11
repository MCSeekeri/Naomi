{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.mcseekeri = {
    isNormalUser = true;
    #description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "kvm"
      "libvirtd"
      "incus-admin"
      "vboxusers"
      "gamemode"
      "wireshark"
    ]
    ++ lib.optionals config.virtualisation.podman.enable [ "podman" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    hashedPassword = "$y$j9T$lwFIo.UGTIFIrxztfMWSf/$YT54vMs0sQim6XLFalhmo3/PtmJ7VTU6kuOWTuZOom6";
  };

  programs = {
    kdeconnect.enable = true;
  };

  home-manager.users.mcseekeri = import ./home-manager.nix;
}

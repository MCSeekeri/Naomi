{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.remote = {
    isNormalUser = true;
    #description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ]
    ++ lib.optionals config.virtualisation.podman.enable [ "podman" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    hashedPassword = "$y$j9T$4qc9V.UC7.yS1YkTwMAdF/$mZgsf2m6sfVHim/miFZ1g8whKLKAuSvqdabSKrekl/B";
  };

  home-manager.users.remote = import ./home-manager.nix;
}

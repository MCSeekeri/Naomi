{ pkgs, config, ... }:
{
  sops.secrets.mcseekeri-pwd = {
    sopsFile = ../../secrets/users.yaml;
    neededForUsers = true;
  };
  users.users.mcseekeri = {
    isNormalUser = true;
    #description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "podman"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    hashedPasswordFile = config.sops.secrets.mcseekeri-pwd.path;
  };
  home-manager.users.mcseekeri = import ./home-manager.nix;
}

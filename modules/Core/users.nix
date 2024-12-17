{ pkgs, ... }:
{
  users = {
    motdFile = "/etc/motd";
    users.mcseekeri = {
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
    };
  };
}
{ pkgs, ... }:
{
  users.users.mihomo = {
    isNormalUser = true;
    #description = "Homo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "podman"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mihomo@outlook.com"
    ];
    hashedPassword = "$y$j9T$JwXXJf493wiqzj0SIrvxd.$v8QxO.X7fJ9qrMrIK9HO6G2.RyajKf6e/T5eb6CcNYC";
  };
  home-manager.users.mihomo = import ./home-manager.nix;
}

{ pkgs, ... }:
{
  users.users.mcseekeri = {
    isNormalUser = true;
    #description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "podman"
      "minecraft" # 访问套接字需要位于这个组……或者 sudo
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    hashedPassword = "$y$j9T$lxgYXhMXDKlSzeS55r.nT/$X0TR61QgiVXNMYpbHOXitEKrtYE7LvKQf/gYgcL3Nc0";
  };
  home-manager.users.mcseekeri = import ./home-manager.nix;
}

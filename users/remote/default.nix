{ pkgs, ... }:
{
  users.users.remote = {
    isNormalUser = true;
    #description = "";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "podman"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ ];
    # hashedPassword = "";
  };
  home-manager.users.remote = import ./home-manager.nix;
}

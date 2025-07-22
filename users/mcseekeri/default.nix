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
      "kvm"
      "libvirtd"
      "incus-admin"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTidxwTS5kyQENgBQ1n4FukaocS1CHhBZ0uaEDifLA0 mcseekeri@outlook.com"
    ];
    hashedPassword = "$y$j9T$lwFIo.UGTIFIrxztfMWSf/$YT54vMs0sQim6XLFalhmo3/PtmJ7VTU6kuOWTuZOom6";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="mcseekeri", GROUP="kvm", MODE="0660"
  '';
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; # DingTalk
  home-manager.users.mcseekeri = import ./home-manager.nix;
}

{
  pkgs,
  inputs,
  config,
  lib,
  self,
  ...
}:
{
  imports = [ inputs.stylix.nixOnDroidModules.stylix ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rebecca.yaml";
    polarity = "dark";
    homeManagerIntegration.autoImport = false;
    overlays.enable = false;
    fonts.monospace = {
      package = pkgs.maple-mono.Normal-NF-CN-unhinted;
      name = "Maple Mono Normal NF CN";
    };
  };

  terminal.colors = with config.lib.stylix.colors.withHashtag; {
    color8 = lib.mkForce base03;
    color15 = lib.mkForce base06;
  };

  environment.packages = with pkgs; [
    git
    fish
    tmux
    ripgrep
    fd
    rsync
    curl
    wget
    jq
    openssh
    age
    sops
    rclone
    proxychains
    gnupg
    pinentry-tty
  ];

  user = {
    shell = "${pkgs.fish}/bin/fish";
    userName = "mcseekeri";
  };

  android-integration = {
    xdg-open.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    termux-reload-settings.enable = true;
  };

  nix = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store?priority=1"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=2"
      "https://nix.mcseekeri.com?priority=51"
    ];
    trustedPublicKeys = [ "nix.mcseekeri.com-1:3gd0/2u7IOF7YooxEiBbWTvRCYGC53S2UoqFdnCUYHc=" ];
    extraOptions = "experimental-features = nix-command flakes";
    registry.nixpkgs.flake = {
      outPath = pkgs.path;
    };
  };

  environment.etcBackupExtension = ".bak";

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit self; };
  };

  system.stateVersion = "24.05";
}

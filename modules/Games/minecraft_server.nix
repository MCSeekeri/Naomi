{ inputs, pkgs, ... }:
let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/MCSeekeri/Minecraft/raw/00000010ddef0d50a6bc20b243c9fd9934b5ec02/pack.toml";
    packHash = "sha256-Gs7/ApTGmTNLfN5opncob+9GZdM/MQFlp7fc9pbxFLc=";
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  # tmux -S /run/minecraft/servername.sock attach 来访问服务器控制台

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.mcserver = {
      enable = true;
      autoStart = true;
      package = pkgs.fabricServers.fabric-1_21_1;
      # whitelist = {
      #   # https://mcuuid.net/
      #   mcseekeri = "f9babfb2-e9a4-4049-97ee-c4cf71659d54";
      # };
      serverProperties = {
        server-port = 25565;
        difficulty = "easy";
        gamemode = "survival";
        motd = "NixOS MC Server";
        allow-cheats = true;
        white-list = true;
        online-mode = false;
        max-players = 20;
        simulation-distance = 10;
        spawn-protection = 0;
        view-distance = 10;
        enable-command-block = true;
      };
      # jvmOpts = "-Xms8192M -Xmx8192M -XX:+UseZGC -XX:+ZGenerational"; # https://noflags.sh/
      symlinks = {
        "mods" = "${modpack}/mods";
      };
      files = {
        "config/ferritecore.mixin.properties" = "${modpack}/config/ferritecore.mixin.properties";
        #   可以手动定义配置文件的值
        #   "config/server-specific.conf".value = {
        #     example = "foo-bar";
        #   };
      };
    };
  };
}

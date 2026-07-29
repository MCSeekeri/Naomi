{
  services.glances = {
    enable = true;
    openFirewall = true;
    extraArgs = [
      "--webserver"
      "--enable-process-extended"
      "--disable-check-update" # Nix 会负责更新
      "--hide-kernel-threads"
      "--diskio-show-ramfs"
      # "--username"
      # "--password"
    ];
  };
}

{
  services.glances = {
    enable = true;
    port = 61208;
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

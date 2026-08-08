{ lib, ... }: {
  services.glances = {
    enable = true;
    openFirewall = lib.mkDefault false;
    extraArgs = [
      "--bind"
      "127.0.0.1"
      "--webserver"
      "--enable-process-extended"
      "--disable-check-update" # Nix 会负责更新
      "--hide-kernel-threads"
      "--diskio-show-ramfs"
    ];
  };
}

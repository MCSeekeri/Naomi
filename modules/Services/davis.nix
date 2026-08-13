{ lib, ... }: {
  services.davis = {
    enable = true;
    nginx = lib.mkDefault null;
    database.driver = lib.mkDefault "postgresql";
    poolConfig = lib.mkDefault {
      "pm" = "ondemand"; # 按需启动，节约内存……
      "pm.max_children" = 4;
      "pm.process_idle_timeout" = "10s";
      "pm.max_requests" = 500;
    };
  };

  services.phpfpm.pools.davis.phpOptions = lib.mkForce ''
    log_errors = on
    memory_limit = 256M
    max_execution_time = 120
  '';
}

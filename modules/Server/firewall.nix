{
  networking.firewall = {
    allowedTCPPorts = [
      22
      80
      443
      3389
    ];
    allowedUDPPorts = [
      80
      443
      7844
    ]; # 防火墙放行端口设置
    allowedTCPPortRanges = [
      # 预留给开发环境
      # 只是提醒一下……如果写了 10000-20000，那么 nix 会真的进行计算，得出 -10000 然后报错
      # 真是聪明的有点傻
      {
        from = 10000;
        to = 20000;
      }
    ];
  };
}

{
  boot = {
    kernelParams = [
      # 从网上抄的，能用就不动
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "pti=on"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "lockdown=confidentiality"
      "quiet"
      "loglevel=0"
      "spectre_v2=on"
      "spec_store_bypass_disable=on"
      "tsx=off"
      "tsx_async_abort=full,nosmt"
      "mds=full,nosmt"
      "l1tf=full,force"
      "nosmt=force"
      "kvm.nx_huge_pages=force"
      "intel_iommu=on"
      "efi=disable_early_pci_dma"
    ];
    blacklistedKernelModules = [
      # 一些几百年没人用的协议
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n-hdlc"
      "x25"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"
      "vivid"
    ];
    kernel.sysctl = {
      # 网络
      "net.core.rmem_max" = 12582912; # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
      "net.core.wmem_max" = 8388608;
      "net.ipv4.icmp_echo_ignore_all" = 1; # 禁止ping
      "net.ipv4.tcp_syncookies" = 1; # 反 SYN 攻击
      "net.ipv4.tcp_rfc1337" = 1; # https://datatracker.ietf.org/doc/html/rfc1337
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0; # 禁用源路由，避免中间人攻击
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.default.accept_ra" = 0; # 禁用 IPv6 路由器通告
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0; # 禁用 TCP SACK https://tools.ietf.org/html/rfc2018
      "net.ipv4.tcp_timestamps" = 0; # 禁用 IPv4 时间戳
      # 内核
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1; # 创建符号链接会验证所有者
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2; # 防止在全局可写的目录里创建文件
      # "vm.max_map_count" = 1048576;
      "fs.suid_dumpable" = 0; # 从 sysctl 禁用出错内存转储
      "vm.swappiness" = 1; # 仅在绝对必要的时候使用虚拟内存
    };
  };
  security = {
    sudo-rs.enable = true; # 锈批！
    sudo-rs.execWheelOnly = true;
    # sudo.execWheelOnly = true; # 只允许 wheel 组执行 sudo
    chromiumSuidSandbox.enable = true; # Chrome 沙盒化
    forcePageTableIsolation = true; # 页表隔离，完全避免熔断漏洞
  };
}

{
  boot = {
    kernelParams = [
      # 从网上抄的，能用就不动
      "debugfs=off"
      "efi=disable_early_pci_dma"
      "init_on_alloc=1"
      "init_on_free=1"
      "intel_iommu=on"
      "kvm.nx_huge_pages=force"
      "lockdown=confidentiality"
      "loglevel=0"
      "mds=full,nosmt"
      "nosmt=force"
      "oops=panic"
      "page_alloc.shuffle=1"
      "page_poison=1"
      "pti=on"
      "quiet"
      "randomize_kstack_offset=on"
      "slab_nomerge"
      "slub_debug=FZP"
      "spec_store_bypass_disable=on"
      "spectre_v2=on"
      "tsx=off"
      "tsx_async_abort=full,nosmt"
      "vsyscall=none"
    ];
    blacklistedKernelModules = [
      "adfs"
      "af_802154"
      "affs"
      "appletalk"
      "atm"
      "ax25"
      "befs"
      "bfs"
      "can"
      "cramfs"
      "dccp"
      "decnet"
      "econet"
      "efs"
      "erofs"
      "exofs"
      "f2fs"
      "firewire-core"
      "floppy"
      "freevxfs"
      "hfs"
      "hpfs"
      "ieee1394"
      "ipx"
      "jfs"
      "minix"
      "n-hdlc"
      "netrom"
      "nilfs2"
      # "ntfs"
      "omfs"
      "p8022"
      "p8023"
      "psnap"
      "qnx4"
      "qnx6"
      "rds"
      "rose"
      "sctp"
      "sysv"
      "tipc"
      "ufs"
      "vivid"
      "x25"
    ];
    kernel.sysctl = {
      # 网络
      # "net.core.bpf_jit_enable" = false; # 禁用 bpf() JIT 防止喷射攻击 # 大鹅需要这个，暂时不能设置

      "net.ipv4.conf.all.accept_redirects" = false;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.all.log_martians" = true; # 记录异常数据包
      "net.ipv4.conf.all.rp_filter" = "1"; # 严格反向路径过滤
      "net.ipv4.conf.all.secure_redirects" = false;
      "net.ipv4.conf.all.send_redirects" = false;

      "net.ipv4.conf.default.accept_redirects" = false;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = "1";
      "net.ipv4.conf.default.send_redirects" = false;

      "net.ipv4.icmp_echo_ignore_all" = 1; # 禁止 ping
      "net.ipv4.icmp_echo_ignore_broadcasts" = true; # 忽略广播 ICMP

      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0; # 禁用 TCP SACK
      "net.ipv4.tcp_rfc1337" = 1; # 防 TIME-WAIT 攻击
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_syncookies" = 1; # 反 SYN 攻击
      "net.ipv4.tcp_timestamps" = 0; # 禁用 IPv4 时间戳

      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.accept_redirects" = false;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_ra" = 0; # 禁用 IPv6 路由器通告
      "net.ipv6.conf.default.accept_redirects" = false;
      "net.ipv6.conf.default.accept_source_route" = 0; # 禁用源路由

      # 内核
      "fs.protected_fifos" = 2;
      "fs.protected_hardlinks" = 1; # 验证符号链接所有者
      "fs.protected_regular" = 2; # 防止全局可写目录创建文件
      "fs.protected_symlinks" = 1;
      "fs.suid_dumpable" = 0; # 禁用出错内存转储

      "kernel.ftrace_enabled" = false; # 禁用 ftrace 调试
      "kernel.kptr_restrict" = 2; # 隐藏 kptrs
      "kernel.randomize_va_space" = 2;
      "kernel.yama.ptrace_scope" = 1; # 限制 ptrace 访问

      "vm.swappiness" = 1; # 仅在必要时使用虚拟内存
    };
  };
  security = {
    auditd.enable = true;
    # chromiumSuidSandbox.enable = true; # Chrome 沙盒化 似乎不可用于 ungoogled-chromium
    forcePageTableIsolation = true; # 页表隔离，完全避免熔断漏洞
    # lockKernelModules = true # 启动后完全禁止内核模块加载，太激进了……
  };
  # environment.memoryAllocator.provider = "graphene-hardened"; # 想给自己找点刺激就打开这个。
}

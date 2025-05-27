# [WARN] 本模块暂时弃用，等待上游讨论出可行的加固解决方案。
{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/profiles/hardened.nix" ];
  boot = {
    kernelParams = [
      "efi=disable_early_pci_dma"
      "kvm.nx_huge_pages=force"
      "lockdown=confidentiality"
      "quiet"
      "randomize_kstack_offset=on"
      "slub_debug=FZP"
      "spec_store_bypass_disable=on"
      "spectre_v2=on"
      "tsx=off"
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
      "net.core.bpf_jit_enable" = true; # 大鹅需要这个

      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.default.log_martians" = true;
      "net.ipv4.conf.default.rp_filter" = "1";

      "net.ipv4.icmp_echo_ignore_all" = 1; # 禁止 ping

      "net.ipv4.tcp_dsack" = 0;
      "net.ipv4.tcp_fack" = 0; # 禁用 TCP SACK
      "net.ipv4.tcp_rfc1337" = 1; # 防 TIME-WAIT 攻击
      "net.ipv4.tcp_sack" = 0;
      "net.ipv4.tcp_syncookies" = 1; # 反 SYN 攻击
      "net.ipv4.tcp_timestamps" = 0; # 禁用 IPv4 时间戳

      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_ra" = 0; # 禁用 IPv6 路由器通告
      "net.ipv6.conf.default.accept_source_route" = 0; # 禁用源路由

      # 内核
      "fs.protected_fifos" = 2;
      "fs.protected_hardlinks" = 1; # 验证符号链接所有者
      "fs.protected_regular" = 2; # 防止全局可写目录创建文件
      "fs.protected_symlinks" = 1;
      "fs.suid_dumpable" = 0; # 禁用出错内存转储

      "kernel.randomize_va_space" = 2;
      "kernel.yama.ptrace_scope" = 1; # 限制 ptrace 访问

      "vm.swappiness" = 1; # 仅在必要时使用虚拟内存
    };
  };
  security = {
    auditd.enable = true;
    lockKernelModules = false; # 启动后完全禁止内核模块加载，太激进了……
  };
  # environment.memoryAllocator.provider = "graphene-hardened"; # 想给自己找点刺激就打开这个。
}

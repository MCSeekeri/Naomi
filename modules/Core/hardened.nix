{
  config,
  lib,
  inputs,
  ...
}:
{
  # 未来可能讲更有意思的话，著更其完美的文，做更其壮丽的事业，但今天只是今天，未来也只是今天的未来。
  # 若留下探索，后人总结；若留下经验，后人咀嚼；若留下教训，后人借鉴；若留下失误，后人避免。

  imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];

  options = {
    security.hardened.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hardened security configurations";
    };
  };

  config = lib.mkIf config.security.hardened.enable {
    nix-mineral = {
      enable = true;
      preset = "compatibility";
      settings = {
        etc.kicksecure-gitconfig = false;
        misc.dnssec = false;
      };
      filesystems.enable = false;
    };

    boot = {
      kernelParams = [
        "slab_nomerge" # 禁止合并堆栈缓存
        "init_on_alloc=1" # 分配内存时自动清零
        "init_on_free=1" # 释放内存时自动清零
        "page_alloc.shuffle=1" # 随机化内存页分配
        "pti=on" # 开启页表隔离
        "randomize_kstack_offset=on" # 随机偏移内核栈
        "vsyscall=none"
        "debugfs=off"
        "oops=panic"
        # "module.sig_enforce=1" # 强制内核模块签名，会炸掉 VirtualBox 和 NVIDIA
        "lockdown=confidentiality" # 启用内核锁定，禁止休眠或者 kexec
      ];
      blacklistedKernelModules = [
        # 过时的网络协议
        "dccp"
        "sctp"
        "rds"
        "tipc"
        "n-hdlc"
        "ax25"
        "netrom"
        "x25"
        "rose"
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

        # 过时的文件系统
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "udf"

        "vivid"
      ];
    };

    services = {
      dbus.implementation = "broker";
      logrotate.enable = true;
    };
  };
}

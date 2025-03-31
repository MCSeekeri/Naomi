{
  virtualisation.virtualbox.host = {
    enable = true; # 添加用户到 vboxusers 用户组以使用
    # headless = true;
    enableExtensionPack = true; # 经常需要编译
    enableKvm = true; # 实验性启用 KVM 后端，不需要内核模块
  };
}

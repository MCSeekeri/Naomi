{
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ]; # https://github.com/NixOS/nixpkgs/issues/363887#issuecomment-2536693220
  virtualisation.virtualbox.host = {
    enable = true; # 添加用户到 vboxusers 用户组以使用
    # headless = true;
    enableExtensionPack = true; # 经常需要编译
    # enableKvm = true; # 实验性启用 KVM 后端，不需要内核模块……但仍然需要编译很多东西
    addNetworkInterface = true; # 自动设置 vboxnet0 网络接口，和 KVM 冲突
    # enableWebService = true;
  };
}

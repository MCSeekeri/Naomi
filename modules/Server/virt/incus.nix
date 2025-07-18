{
  virtualisation = {
    # 因为 Incus 的名字很好听，所以换过来（
    # Canonical 这家公司实在是太不 Canonical 了
    lxc.lxcfs.enable = true;
    incus = {
      enable = true; # 添加用户到 incus-admin 或 incus 用户组
      ui.enable = true;
      socketActivation = false; # 会影响开机启动
    };
  };
  networking = {
    nftables.enable = true;
    firewall.interfaces.incusbr0 = {
      allowedTCPPorts = [
        53
        67
      ];
      allowedUDPPorts = [
        53
        67
      ];
    };
  };
}

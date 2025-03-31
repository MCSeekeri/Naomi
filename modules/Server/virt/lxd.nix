{
  virtualisation = {
    lxc.lxcfs.enable = true;
    lxd = {
      enable = true;
      agent.enable = true;
      recommendedSysctlSettings = true;
      ui.enable = true;
    };
  };
}

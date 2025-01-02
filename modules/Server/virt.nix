{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true; # 不知道为什么这年头所有人都在讲 TPM
    };
  };
}

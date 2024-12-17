{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true; # 不知道为什么这年头所有人都在讲 TPM
    };
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true; # 用户体验不变
      networkSocket.openFirewall = true;
    };
  };
}

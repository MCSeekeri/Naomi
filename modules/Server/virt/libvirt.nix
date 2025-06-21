{ pkgs, ... }:
{
  # 确保将用户添加到 kvm 和 libvirtd 组
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true; # 不知道为什么这年头所有人都在讲 TPM
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        vhostUserPackages = [ pkgs.virtiofsd ]; # VirtioFS
        verbatimConfig = ''
          cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/kvmfr0"
          ]
        '';
      };
    };
  };
  programs.virt-manager.enable = true;
}

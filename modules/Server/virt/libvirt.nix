{ pkgs, ... }:
{
  # [WARN] 因为多种原因，libvirtd 的配置有些问题，暂时不推荐使用。
  virtualisation = {
    spiceUSBRedirection.enable = true; # USB 重定向
    libvirtd = {
      enable = true; # libvirtd 组内的用户才能调用 virsh
      qemu = {
        swtpm.enable = true; # 不知道为什么这年头所有人都在讲 TPM
        vhostUserPackages = [ pkgs.virtiofsd ]; # VirtioFS
      };
    };
  };
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [ quickemu ];
}

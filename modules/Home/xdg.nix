{ lib, ... }:
{
  # 设置 XDG 用户目录为英文，避免一些不必要的终端悲剧。
  xdg = {
    enable = lib.mkDefault true;
    userDirs = {
      enable = lib.mkDefault true;
      createDirectories = lib.mkDefault true;
    };
  };
  home.preferXdgDirectories = lib.mkDefault true;
}

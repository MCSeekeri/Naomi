{
  # 设置 XDG 用户目录为英文，避免一些不必要的终端悲剧。
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps.enable = true;
  };
}

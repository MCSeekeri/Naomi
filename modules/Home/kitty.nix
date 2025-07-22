{ pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      scrollback_pager_history_size = 100;
      enable_audio_bell = false; # 防止把自己吓一跳，如果你好奇，输入 wall 随便什么。
      update_check_interval = 0;
      confirm_os_window_close = 0; # 我知道我在做什么
    };
    extraConfig = ''
      globinclude kitty.d/**/*.conf # 允许用户自定义
    '';

    font = {
      name = lib.mkForce "Maple Mono Normal CN";
      package = lib.mkForce pkgs.maple-mono.Normal-CN-unhinted; # Kitty 会自动处理 Nerd Fonts，所以可以不带 NF.
      size = lib.mkForce 16; # 大就是好。
    };
  };
}

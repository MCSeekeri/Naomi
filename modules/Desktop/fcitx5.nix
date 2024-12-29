{ pkgs, ... }:
{
  # 设置 fcitx5 为默认输入方案
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-zhwiki
        fcitx5-fluent
      ];
    };
  };
}

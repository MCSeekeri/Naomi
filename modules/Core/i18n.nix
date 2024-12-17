{ pkgs, ... }:
{
  i18n = {
    # 默认语言不要设置为中文，tty 下会出大悲剧
    defaultLocale = "en_US.UTF-8";
    # 设置 fcitx5 为默认输入方案
    inputMethod = {
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
  };
}

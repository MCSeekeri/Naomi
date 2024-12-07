{
  config,
  pkgs,
  stdenv,
  ...
}:

{
  fonts.fontconfig.enable = true; # 允许用户自定义字体
  home = {
    username = "mcseekeri";
    homeDirectory = "/home/mcseekeri";
    stateVersion = "24.11";

    packages = with pkgs; [
      #命令行
      fishPlugins.tide
      fishPlugins.done
      fishPlugins.autopair
      # fishPlugins.fish-you-should-use # 等写了一堆缩写之后再考虑
      # fishPlugins.sponge # 带来的问题比解决的问题多
      # 桌面应用
      librewolf
      ungoogled-chromium
      thunderbird
      xdg-desktop-portal
      xdg-dbus-proxy
      keepassxc
      kdePackages.xdg-desktop-portal-kde
      qq
      wpsoffice-cn
      # 游戏娱乐
      moonlight-qt
      # 输入法
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-zhwiki
      fcitx5-fluent
    ];
  };

  programs = {
    home-manager.enable = true;
    librewolf.languagePacks = [ "zh-CN" ];
    git = {
      enable = true;
      userName = "MCSeekeri";
      userEmail = "mcseekeri@outlook.com";
    };
    fish = {
      enable = true; # 比 zsh 更好，可惜不兼容 bash
      shellAliases = {
        conda = "micromamba";
        proxy = "proxychains4 -q";
      };
    };
    obs-studio = {
      enable = true;
    };

  };
  services = {
    kdeconnect.enable = true;
    flameshot.enable = true;
  };
  # TODO: 输入法，Plasma 配置，字体微调，预置主题(?)
}

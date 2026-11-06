{ pkgs, inputs, ... }: {
  # 旁边站着一太监，拿手一指这和尚:"哼，你道德上有问题。"
  # 和尚回头看看:"哪个太监说的？"
  # ——郭德纲 《济公传》

  nixpkgs.overlays = [ inputs.chinese-fonts-overlay.overlays.default ];

  fonts = {
    packages = with pkgs; [
      (microsoftPackages.combine' "windows-fonts-zh" (
        drv:
        builtins.elem drv.pname [
          "microsoft-microsoft-yahei"
          "microsoft-simsun"
          "microsoft-simhei"
          "microsoft-kaiti"
          "microsoft-fangsong"
          "microsoft-dengxian"
          "microsoft-times-new-roman"
          "microsoft-arial"
          "microsoft-calibri"
          "microsoft-cambria"
          "microsoft-courier-new"
        ]
      ))
      zpix-pixel-font

      lxgw-wenkai
      lxgw-neoxihei
      smiley-sans
      foundertype-fonts
      tianheng-fonts
    ];
  };
}

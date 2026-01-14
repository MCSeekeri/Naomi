{ pkgs, inputs, ... }:
{
  # 旁边站着一太监，拿手一指这和尚:"哼，你道德上有问题。"
  # 和尚回头看看:"哪个太监说的？"
  # ——郭德纲 《济公传》

  nixpkgs.overlays = [ inputs.chinese-fonts-overlay.overlays.default ];

  fonts = {
    packages = with pkgs; [
      windows-fonts # vista-fonts 的上位替代
      inter

      # 代码用字体
      cascadia-code
      jetbrains-mono
      hack-font
      fira-code

      # 汉字
      babelstone-han
      zpix-pixel-font

      lxgw-wenkai
      lxgw-neoxihei
      smiley-sans
      foundertype-fonts
      TH-fonts

      lxgw-wenkai-tc

      jigmo
      mplus-outline-fonts.githubRelease # OSDN 居然还有人续命
    ];
  };
}

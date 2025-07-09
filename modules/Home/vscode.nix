{ pkgs, lib, ... }:
{
  programs = {
    vscode = {
      enable = true;
      # package = pkgs.vscode-fhs;
      profiles.default.extensions = with pkgs.vscode-marketplace; [
        huacnlee.autocorrect
        mhutchie.git-graph
        ms-ceintl.vscode-language-pack-zh-hans
        ms-vscode-remote.remote-ssh
        ms-vscode.remote-explorer
        redhat.vscode-xml
        redhat.vscode-yaml
      ];
    };
  };

  stylix.targets.vscode.enable = lib.mkForce false;
  # 字体最好由用户手动设置，而不是 Stylix 默认
  # 等宽和宋体混杂别提多难受了
}

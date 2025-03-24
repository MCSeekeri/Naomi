{ pkgs, ... }:
{
  programs = {
    vscode = {
      enable = true;
      # package = pkgs.vscode-fhs;
      extensions = with pkgs.vscode-marketplace; [
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
}

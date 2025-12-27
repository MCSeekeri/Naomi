{ pkgs, ... }:
{
  # *罐头笑声*
  home = {
    packages = with pkgs; [
      claude-code
      gemini-cli
      qwen-code
      github-copilot-cli

      warp-terminal
      crush
    ];
  };
}

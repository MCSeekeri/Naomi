{ pkgs, ... }:
{
  # *罐头笑声*
  home = {
    packages = with pkgs; [
      claude-code
      gemini-cli
      qwen-code
      github-copilot-cli
      codex
      opencode

      warp-terminal
      crush

      antigravity-fhs
    ];
  };
}

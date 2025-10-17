{ pkgs, ... }:
{
  # *罐头笑声*
  home = {
    packages = with pkgs; [
      claude-code
      gemini-cli
      warp-terminal
      # crush # [TODO] 等待 25.11
    ];
  };
}

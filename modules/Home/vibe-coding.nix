{ pkgs, ... }:
{
  # *罐头笑声*
  environment.systemPackages = with pkgs; [
    alpaca
    aichat
    fabric-ai
    aider-chat
  ];
}

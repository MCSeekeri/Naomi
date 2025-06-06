{ pkgs, ... }:
{
  # https://mosh.org/
  # 一个用来在极端网络环境下进行 SSH 访问的程序

  programs.mosh = {
    enable = true;
    programs.mosh.openFirewall = false;
  };

  environment.systemPackages = with pkgs; [ mosh ];
}

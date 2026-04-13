{ pkgs, self, ... }:
{
  imports = [
    "${self}/modules/Home/fish/tide.nix"
    "${self}/modules/Home/direnv.nix"
  ];

  home = {
    username = "remote";
    homeDirectory = "/home/remote";
    stateVersion = "25.11";

    packages = with pkgs; [
      # 开发套件
      uv
      rustup
      gnumake
      musl
      nodejs
      pnpm
      yarn-berry
      # 常用工具
      nix-diff
      rclone
    ];
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellAliases = {
        proxy = "proxychains4 -q";
      };
    };
  };
}

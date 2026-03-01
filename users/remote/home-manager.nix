{ pkgs, self, ... }:
{
  imports = [
    "${self}/modules/Home/fish/tide.nix"
    "${self}/modules/Home/awesome-terminal.nix"
    "${self}/modules/Home/direnv.nix"
    "${self}/modules/Home/git.nix"
    "${self}/modules/Home/kitty.nix"
    "${self}/modules/Home/sops.nix"
    "${self}/modules/Home/xdg.nix"
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
      nixpkgs-review
      lucky-commit
      pkg-config
      nodejs
      pnpm
      yarn-berry
      # 终端增强
      mycli
      pgcli
      iredis
      usql
      # 常用工具
      nix-diff
      yt-dlp
      rclone
      nixos-anywhere
      cachix
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

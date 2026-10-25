{ pkgs, self, ... }: {
  imports = [ "${self}/modules/Home/direnv.nix" ];

  home = {
    username = "remote";
    homeDirectory = "/home/remote";
    stateVersion = "26.11";

    packages = with pkgs; [
      # 开发套件
      rustup
      gnumake
      musl
      nodejs
      yarn-berry
      # 常用工具
      nix-diff
    ];
  };

  programs = {
    home-manager.enable = true;
    fish.enable = true;
    pnpm.enable = true;
    rclone.enable = true;
  };
}

{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      kitty
      upx
      lazygit
      delta # git diff
      git-ignore
      gitleaks # 查找文件或仓库中的敏感信息
      git-secrets
      xh # curl
      # noti # fish done
      magic-wormhole-rs
      sd
      duf # df -h
      gh
      trash-cli
      pandoc
      chafa
      rsclock
      cava
    ];
  };
}

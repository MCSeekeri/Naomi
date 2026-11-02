{ pkgs, ... }: {
  programs.java = {
    enable = true;
    binfmt = true;
  };

  environment = {
    systemPackages = with pkgs; [
      hmcl
      prismlauncher
      mcaselector
      packwiz
      zulu17
      zulu25
    ];
  };
}

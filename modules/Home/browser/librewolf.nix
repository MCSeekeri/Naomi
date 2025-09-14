{ inputs, pkgs, ... }:
{
  programs = {
    librewolf = {
      enable = true;
      package = pkgs.librewolf-bin;
      languagePacks = [ "zh-CN" ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = { };
      };
      profiles = {
        user = {
          settings = {
            # 显然，我需要对照一下标准 Librewolf 和网上的那些配置项之间的差异……
            # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
            # 考虑加入 betterfox
            "extensions.autoDisableScopes" = 0;
            "privacy.resistFingerprinting.letterboxing" = true;
            "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          };
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            # https://discourse.nixos.org/t/firefox-extensions-with-home-manager/34108/4
            ublock-origin
            violentmonkey
            multi-account-containers
            temporary-containers
          ];
        };
      };
    };
  };
  stylix.targets.librewolf.profileNames = [ "user" ];
}

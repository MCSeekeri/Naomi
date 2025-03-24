{ inputs, pkgs, ... }:
{
  programs = {
    librewolf = {
      enable = true;
      # package = pkgs.librewolf;
      languagePacks = [ "zh-CN" ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        Preferences = { };
      };
      profiles = {
        user = {
          settings = {
            "extensions.autoDisableScopes" = 0;
            "privacy.resistFingerprinting.letterboxing" = true;
            "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          };
          extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
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
}

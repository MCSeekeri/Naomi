{ pkgs, ... }:
{
  programs = {
    librewolf = {
      enable = true;
      package = pkgs.librewolf;
      profiles = {
        user = {
          settings = {
            # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg

            # Home Manager 负责扩展更新
            "extensions.autoDisableScopes" = 0;
            "extensions.update.autoUpdateDefault" = false;
            "extensions.update.enabled" = false;

            # Securefox
            "browser.sessionstore.interval" = 60000;
            "browser.privatebrowsing.resetPBM.enabled" = true;
            "browser.urlbar.groupLabels.enabled" = false;
            "signon.privateBrowsingCapture.enabled" = false;
            # "editor.truncate_user_pastes" = false; # 密码长度截断
            "permissions.default.desktop-notification" = 2;
            "permissions.default.geo" = 2;
            "extensions.getAddons.cache.enabled" = false;

            # Peskyfox
            # "browser.profiles.enabled" = true;
            # "browser.compactmode.show" = true;
            "browser.ml.linkPreview.enabled" = false;
            "full-screen-api.transition-duration.enter" = "0 0";
            "full-screen-api.transition-duration.leave" = "0 0";
            # "browser.download.open_pdf_attachments_inline" = true;
            # "browser.bookmarks.openInTabClosesMenu" = false;
            "browser.menu.showViewImageInfo" = true;
            "findbar.highlightAll" = true;
            "layout.word_select.eat_space_to_next_word" = true;

            # 杂项
            "privacy.resistFingerprinting.letterboxing" = true;
            "intl.accept_languages" = "en-US,en";
            "browser.sessionstore.resume_from_crash" = false;
            "browser.translations.automaticallyPopup" = false;
            "browser.urlbar.suggest.recentsearches" = false;
            "browser.urlbar.suggest.bookmark" = true; # 真正意义上的历史记录

            "widget.use-xdg-desktop-portal.file-picker" = 1; # 使用 XDG 来访问系统相关的东西
            "widget.use-xdg-desktop-portal.mime-handler" = 1;
            "widget.use-xdg-desktop-portal.open-uri" = 1;
            "widget.use-xdg-desktop-portal.settings" = 1;
          };
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              # https://discourse.nixos.org/t/firefox-extensions-with-home-manager/34108/4
              ublock-origin
              violentmonkey
              multi-account-containers
              temporary-containers-plus
              bilisponsorblock
            ];
          };
        };
      };
    };
  };
  stylix.targets.librewolf.profileNames = [ "user" ];
}

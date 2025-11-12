{ pkgs, ... }:
{
  programs = {
    librewolf = {
      enable = true;
      package = pkgs.librewolf-bin;
      languagePacks = [ "zh-CN" ];
      policies = {
        RequestedLocales = [ "zh-CN" ];
      };
      profiles = {
        user = {
          settings = {
            # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg

            # Home Manager 负责扩展更新
            "extensions.autoDisableScopes" = 0;
            "extensions.update.autoUpdateDefault" = false;
            "extensions.update.enabled" = false;

            # Fastfox
            "gfx.content.skia-font-cache-size" = 32;
            "gfx.canvas.accelerated.cache-items" = 32768;
            "gfx.canvas.accelerated.cache-size" = 4096;
            "webgl.max-size" = 16384;
            "browser.cache.memory.capacity" = 131072;
            "browser.cache.memory.max_entry_size" = 20480;
            "browser.sessionhistory.max_total_viewers" = 4;
            "browser.sessionstore.max_tabs_undo" = 10;
            "media.memory_cache_max_size" = 262144;
            "media.memory_caches_combined_limit_kb" = 1048576;
            "media.cache_readahead_limit" = 600;
            "media.cache_resume_threshold" = 300;
            "image.cache.size" = 10485760;
            "image.mem.decode_bytes_at_a_time" = 65536;
            "network.http.max-connections" = 1800;
            "network.http.max-persistent-connections-per-server" = 10;
            "network.http.max-urgent-start-excessive-connections-per-host" = 5;
            "network.http.request.max-start-delay" = 5;
            "network.http.pacing.requests.enabled" = false;
            "network.dnsCacheEntries" = 10000;
            "network.dnsCacheExpiration" = 3600;
            "network.ssl_tokens_cache_capacity" = 10240;
            "network.dns.disablePrefetchFromHTTPS" = true;

            # Securefox
            # "privacy.trackingprotection.allow_list.baseline.enabled" = true;
            "browser.sessionstore.interval" = 60000;
            "browser.privatebrowsing.resetPBM.enabled" = true;
            "browser.urlbar.groupLabels.enabled" = false;
            "signon.privateBrowsingCapture.enabled" = false;
            # "editor.truncate_user_pastes" = false; # 密码长度截断
            # "security.mixed_content.block_display_content" = true;
            "permissions.default.desktop-notification" = 2;
            "permissions.default.geo" = 2;
            "extensions.getAddons.cache.enabled" = false;

            # Peskyfox
            "browser.privatebrowsing.vpnpromourl" = "";
            # "browser.profiles.enabled" = true;
            # "browser.compactmode.show" = true;
            "browser.ml.linkPreview.enabled" = false;
            "full-screen-api.transition-duration.enter" = "0 0";
            "full-screen-api.transition-duration.leave" = "0 0";
            "full-screen-api.warning.timeout" = 0;
            # "browser.download.open_pdf_attachments_inline" = true;
            # "browser.bookmarks.openInTabClosesMenu" = false;
            "browser.menu.showViewImageInfo" = true;
            "findbar.highlightAll" = true;

            # 杂项
            "privacy.resistFingerprinting.letterboxing" = true;
            "intl.accept_languages" = "en-US,en";
            "browser.sessionstore.resume_from_crash" = false;
            "browser.translations.automaticallyPopup" = false;
            "browser.urlbar.suggest.recentsearches" = false;
            "browser.urlbar.suggest.bookmark" = true; # 真正意义上的历史记录
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

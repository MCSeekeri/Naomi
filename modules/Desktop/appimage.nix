{ pkgs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;

    package = pkgs.symlinkJoin {
      name = "appimage-run-wrapper";
      meta.mainProgram = "appimage-run";
      paths = [
        (pkgs.appimage-run.override {
          extraPkgs = pkgs: [
            # 我测试了 182 个 AppImage 文件才得到的完美兼容列表
            # 来证明我是错的！

            pkgs.exiftool # Kdenlive
            pkgs.ffmpeg # 不解释
            pkgs.glib # Audacity ColorGenerator
            pkgs.gtk2 # AKASHA Aphelion brackets-electron BrainVerse buche dragoman Skrifa
            pkgs.icu # v2rayN
            pkgs.libayatana-appindicator # Piliplus
            pkgs.libepoxy # appimagepool
            pkgs.libjpeg8 # Spotube
            pkgs.libva
            pkgs.libxau # dukto
            pkgs.libxcrypt-legacy
            pkgs.libxml2 # GSequencer
            pkgs.lz4 # Reqable
            pkgs.mpv
            pkgs.sqlcipher # Element
            pkgs.webkitgtk_4_1 # JHentai
            pkgs.libxcb-cursor # Qt 6 xcb
          ];
        })
      ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild =
        # QT 魔法，防止不同版本的打架
        ''
          mv $out/bin/appimage-run $out/bin/.appimage-run-wrapped
          makeWrapper $out/bin/.appimage-run-wrapped $out/bin/appimage-run \
            --unset QML2_IMPORT_PATH \
            --unset QML_IMPORT_PATH \
            --unset QT_PLUGIN_PATH \
            --unset QT_QPA_PLATFORMTHEME
        '';
    };
  };
}

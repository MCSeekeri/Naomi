{
  pkgs,
  config,
  lib,
  ...
}:
{
  # nixpkgs.overlays = [ inputs.nix-alien.overlays.default ];

  # environment = {
  #   systemPackages = with pkgs; [ nix-alien ];
  # };

  # services.envfs.enable = true; # 会让 QQ 启动后无法渲染图标，无法理解

  # 只是提醒一下……启动 nix-ld 相关配置之后会允许 NixOS 执行标准 Linux 二进制，包括病毒
  # 所以，谨慎考虑
  programs = {
    nix-ld = {
      libraries =
        # https://github.com/Alper-Celik/MyConfig/blob/main/Configs/nix-ld.os.nix
        # 这哥们为什么要写好几遍……
        lib.mkAfter (
          with pkgs;
          [
            acl
            attr
            bzip2
            curl
            dbus
            dbus-glib
            e2fsprogs
            expat
            fuse
            fuse3
            gmp
            gnutls
            icu
            keyutils.lib
            libcap
            libgcc
            libgcrypt
            libgpg-error
            libidn
            libproxy
            libsodium
            libssh
            libtool.lib
            libudev0-shim
            libunwind
            libusb1
            libuuid
            libxcrypt
            libxcrypt-legacy
            libxml2
            ncurses
            nspr
            nss
            onetbb
            openssl
            p11-kit
            python3
            sqlite
            stdenv.cc.cc
            systemd
            udev
            util-linux
            xz
            zlib
            zstd
          ]
          ++ lib.optionals config.hardware.graphics.enable [
            alsa-lib
            at-spi2-core
            cairo
            colord
            cups
            desktop-file-utils
            flac
            flite
            fontconfig
            freetype
            fribidi
            gdk-pixbuf
            glew_1_10
            glfw
            glib
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-ugly
            gst_all_1.gstreamer
            gtk2
            gtk3
            harfbuzz
            kdePackages.qtbase
            libappindicator
            libayatana-appindicator
            libcaca
            libcanberra
            libclang.lib
            libdbusmenu
            libdrm
            libepoxy
            libgbm
            libGLU
            libglvnd
            libice
            libjack2
            libjpeg
            libjpeg8
            libmikmod
            libogg
            libpciaccess
            libpng
            libpng12
            libpulseaudio
            librsvg
            libsamplerate
            libsForQt5.qtbase
            libsm
            libsndfile
            libthai
            libtheora
            libtiff
            libva
            libvdpau
            libvorbis
            libvpx
            libwebp
            libx11
            libxcb
            libxcb-keysyms
            libxcb-render-util
            libxcb-wm
            libxcomposite
            libxcursor
            libxdamage
            libxext
            libxfixes
            libxft
            libxi
            libxinerama
            libxkbcommon
            libxkbfile
            libxmu
            libxpm
            libxrandr
            libxrender
            libxscrnsaver
            libxshmfence
            libxt
            libxtst
            libxxf86vm
            mesa
            mpv # PiliPlus
            openal
            pango
            pciutils
            pipewire
            pixman
            SDL
            SDL2
            SDL2_image
            SDL2_mixer
            SDL2_ttf
            SDL_image
            SDL_mixer
            SDL_ttf
            speex
            vulkan-loader
            wayland
            xcbutilxrm
            xkeyboard-config
          ]
        );
      # 笑点解析：用 itch.io 上面的黄油来测试配置之后对 Linux 二进制的兼容性
      # 其实还是挺准确的，因为游戏吃的运行库又多又杂
    };
  };
}

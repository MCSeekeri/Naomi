{
  pkgs,
  config,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.nix-alien.overlays.default ];

  environment.systemPackages = with pkgs; [ nix-alien ];

  services.envfs.enable = true;

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld = {
      enable = true;
      libraries =
        # https://github.com/Alper-Celik/MyConfig/blob/main/Configs/nix-ld.os.nix
        # 这哥们为什么要写好几遍……
        with pkgs;
        [
          acl
          attr
          bzip2
          curl
          dbus
          dbus-glib
          desktop-file-utils
          e2fsprogs
          expat
          flac
          flite
          fontconfig
          freetype
          fribidi
          fuse
          fuse3
          gmp
          icu
          keyutils.lib
          libcap
          libgbm
          libgcc
          libgcrypt
          libgpg-error
          libidn
          libmikmod
          libogg
          libpng12
          libsamplerate
          libsodium
          libssh
          libthai
          libtheora
          libtiff
          libudev0-shim
          libunwind
          libusb1
          libuuid
          libvorbis
          libvpx
          libxcrypt
          libxcrypt-legacy
          libxml2
          libtool.lib
          nspr
          nss
          openssl
          p11-kit
          pixman
          python3
          speex
          stdenv.cc.cc
          systemd
          tbb
          udev
          util-linux
          xz
          zlib
          zstd
        ]
        ++ lib.optionals config.hardware.graphics.enable [
          alsa-lib
          at-spi2-atk
          at-spi2-core
          atk
          cairo
          cups
          gdk-pixbuf
          glew110
          glib
          glfw
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-ugly
          gst_all_1.gstreamer
          gtk2
          gtk3
          harfbuzz
          libGL
          libGLU
          libappindicator-gtk2
          libappindicator-gtk3
          libcaca
          libcanberra
          libclang.lib
          libdbusmenu
          libdrm
          libglvnd
          libjack2
          libjpeg
          libpulseaudio
          librsvg
          libva
          libvdpau
          libxkbcommon
          mesa
          openal
          pango
          pciutils
          pipewire
          SDL
          SDL2
          SDL2_image
          SDL2_mixer
          SDL2_ttf
          SDL_image
          SDL_mixer
          SDL_ttf
          vulkan-loader
          wayland
          xorg.libICE
          xorg.libSM
          xorg.libX11
          xorg.libXScrnSaver
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXft
          xorg.libXi
          xorg.libXinerama
          xorg.libXmu
          xorg.libXrandr
          xorg.libXrender
          xorg.libXt
          xorg.libXtst
          xorg.libXxf86vm
          xorg.libpciaccess
          xorg.libxcb
          xorg.xcbutil
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.xcbutilwm
          xorg.xkeyboardconfig
          xorg.libxshmfence
        ];
      # 笑点解析：用 itch.io 上面的黄油来测试配置之后对 Linux 二进制的兼容性
      # 其实还是挺准确的，因为游戏吃的运行库又多又杂
    };
  };
}

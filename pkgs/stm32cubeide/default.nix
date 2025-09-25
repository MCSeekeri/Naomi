{
  lib,
  buildFHSEnv,
  requireFile,
  stdenvNoCC,
  unzip,
  ncurses5,
  glib,
  gtk3,
  xorg,
  zlib,
  krb5,
  libusb1,
  makeDesktopItem,
  extraPkgs ? [ ],
}:
# https://github.com/andreasrid/nur-packages/blob/master/pkgs/stm32cubeide/default.nix
let
  package = stdenvNoCC.mkDerivation rec {
    pname = "stm32cubeide";
    version = "1.19.0_25607_20250703_0907";

    src = requireFile {
      name = "st-stm32cubeide_1.19.0_25607_20250703_0907_amd64.sh.zip";
      url = "https://www.st.com/en/development-tools/stm32cubeide.html";
      sha256 = "sha256-+jeXv7+ywRhgQAIl7aFCnRzhbVJZPlW6JICvGLacPG0=";
    };

    nativeBuildInputs = [ unzip ];

    sourceRoot = ".";
    unpackPhase = ''
      unzip $src
    '';

    buildPhase = ''
      chmod +rx st-stm32cubeide_${version}_amd64.sh
      ./st-stm32cubeide_${version}_amd64.sh --noexec --nox11 --target .
    '';

    installPhase = ''
      mkdir -p $out/{bin,opt/STM32CubeIde}

      tar -C $out/opt/STM32CubeIde -x -f st-stm32cubeide_1.19.0_25607_20250703_0907_amd64.tar.gz
      ln -s /opt/STM32CubeIde/stm32cubeide $out/bin/

      chmod +rx ./st-stlink-server.*.install.sh
      ./st-stlink-server.*.install.sh --noexec --nox11 --target $out/opt/stlink-server
      ln -s /opt/stlink-server/stlink-server $out/bin/

      #mkdir -p stlink-udev
      #chmod +rx st-stlink-udev-rules-*-linux-noarch.sh
      #./st-stlink-udev-rules-*-linux-noarch.sh --quiet --noexec --nox11 --target $out/opt/stlink-udev

      #mkdir jlink-udev
      #./segger-jlink-udev-rules-*-linux-noarch.sh --quiet --noexec --nox11 --target $out/opt/jlink-udev
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "stm32cubeide";
        desktopName = "STM32CubeIDE";
        icon = "stm32cubeide";
        exec = "stm32cubeide";
        categories = [
          "Development"
          "IDE"
        ];
        comment = "An all-in-one multi-OS development tool for STM32 microcontrollers";
      })
    ];

    postInstall = ''
      install -m 444 -D /opt/STM32CubeIde/icon.xpm $out/share/icons/hicolor/256x256/apps/stm32cubeide.xpm
    '';

    meta = with lib; {
      description = "An all-in-one multi-OS development tool, which is part of the STM32Cube software ecosystem";
      homepage = "https://www.st.com/en/development-tools/stm32cubeide.html";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      maintainers = with maintainers; [ ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
buildFHSEnv {
  inherit (package)
    pname
    version
    meta
    desktopItems
    ;
  runScript = "stm32cubeide";
  targetPkgs =
    let
      ncurses' = ncurses5.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [ "--with-termlib" ];
        postFixup = "";
      });
    in
    _:
    [
      package
      glib
      gtk3
      xorg.libX11
      xorg.libXext
      xorg.libXtst
      xorg.libXrender
      xorg.libXi
      zlib
      krb5.lib
      ncurses'
      (ncurses'.override { unicodeSupport = false; })
      libusb1
    ]
    ++ extraPkgs;
}

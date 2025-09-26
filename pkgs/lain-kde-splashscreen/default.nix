{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "lain-kde-splashscreen";
  version = "0-unstable-2025-06-26";
  src = fetchFromGitHub {
    owner = "dgudim";
    repo = "themes";
    rev = "3b9817400a0e5d2746ac7a00f67098f9b8469d66";
    hash = "sha256-NatYYX0CVRx59TMM1sXg84PmMSqZ5Ul6StmVpFOUWIk=";
  };
  installPhase = ''
    mkdir -p $out/share/plasma/look-and-feel
    cp -aR KDE-loginscreens/Lain/ $out/share/plasma/look-and-feel/Lain
  '';

  meta = {
    homepage = "https://github.com/dgudim/themes";
    license = lib.licenses.unfree;
  };
}

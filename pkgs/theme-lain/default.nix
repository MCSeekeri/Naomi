{ pkgs,stdenv }:

stdenv.mkDerivation rec {
  pname = "theme-lain";
  version = "ce5c8a0acf48eb116882f04fe731339b0f710927";
  src = pkgs.fetchFromGitHub {
    owner = "dgudim";
    repo = "themes";
    rev = "ce5c8a0acf48eb116882f04fe731339b0f710927";
    hash = "sha256-GVZWWJvaZjO2YvhSIpEVUakkEXnWcfwg3E+1QXHuDeY=";
  };
  installPhase = ''
    mkdir -p $out/share/plasma/look-and-feel
    cp -aR KDE-loginscreens/Lain/ $out/share/plasma/look-and-feel/Lain
  '';
}
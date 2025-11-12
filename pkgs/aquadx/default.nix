{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquadx";
  version = "0-unstable-2025-10-24";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "d2608472d82ccc01c38db5eb8ef56a0a93212ebd";
    hash = "sha256-EZAGTnzbn8TA5D7rSe19ypFNu3/rfo/4NIScXu1g8Kg=";
  };
  nativeBuildInputs = [
    gradle_8
    jdk21
  ];
  mitmCache = gradle_8.fetchDeps {
    pkg = finalAttrs;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8 " ];

  gradleBuildTask = "build";

  installPhase = ''
    mkdir -p $out
    cp build/libs/AquaDX-*.jar $out/
  '';

  meta = {
    description = "A certain magical arcade server";
    homepage = "https://github.com/MewoLab/AquaDX";
    changelog = "https://github.com/MewoLab/AquaDX/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [ MCSeekeri ];
    mainProgram = "aquadx";
    platforms = lib.platforms.all;
  };
})

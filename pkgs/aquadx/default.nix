{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquadx";
  version = "6b99ab";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "6b99ab9e43ecca112f2ad94679f2588bfcbbcc09";
    hash = "sha256-Sb3oFwR//MS9bCCjd5uIm3SNi5KkIbjC98DY0B7/wHk=";
  };
  nativeBuildInputs = [
    gradle_8
    jdk21
  ];
  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquadx";
  version = "0-unstable-2025-09-26";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "68820d5a8682bc59d0148d9ca2a341b6c337cd37";
    hash = "sha256-tio6IzhQbwfWswDY49EZWz/xrC9q6oY4yUk00Bwjbyg=";
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

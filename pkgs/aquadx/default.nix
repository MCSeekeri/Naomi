{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquadx";
  version = "0-unstable-2026-02-09";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "50a9a2bdd042672048ddc254b69744d1dff69098";
    hash = "sha256-/eN2ErlNgfUf/Ns52c/gs+szUyegu1hrURuA+cUf3JU=";
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

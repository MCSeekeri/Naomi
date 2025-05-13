{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquadx";
  version = "a3b3b3";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "a3b3b3dd9329d061d2ce79b257dbd646e5fd3683";
    hash = "sha256-Mi7iqJCeQo43jAplQNZb97+63zfwZbATK7uVy+LoVWQ=";
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

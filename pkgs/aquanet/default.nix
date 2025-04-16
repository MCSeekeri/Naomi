{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "6b99ab9";

  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "6b99ab9e43ecca112f2ad94679f2588bfcbbcc09";
    hash = "sha256-Sb3oFwR//MS9bCCjd5uIm3SNi5KkIbjC98DY0B7/wHk=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pkgs.pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/AquaNet";
    hash = "sha256-+kZa62a8UJ8x7XgkLnoOnxprZD/Nb8e/D07pPwX/3+k=";
  };
  pnpmRoot = "AquaNet";

  postUnpack = ''
    cp ${./.env} $sourceRoot/AquaNet/.env
  '';

  buildPhase = ''
    cd AquaNet
    pnpm run build
  '';

  installPhase = ''
    mkdir -p $out
    cp -aR dist/* $out/
  '';

  meta = {
    description = "A certain magical arcade server";
    homepage = "https://github.com/MewoLab/AquaDX/tree/v1-dev/AquaNet";
    license = lib.licenses.cc-by-nc-sa-40;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mcseekeri ];
  };
})

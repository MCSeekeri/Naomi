{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "0-unstable-2025-09-26";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "68820d5a8682bc59d0148d9ca2a341b6c337cd37";
    hash = "sha256-tio6IzhQbwfWswDY49EZWz/xrC9q6oY4yUk00Bwjbyg=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pkgs.pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/AquaNet";
    hash = "sha256-oVDqrAxcjTKLL042pNIBdNaNQHpydSYQjbYBcc5I6Ec=";
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

{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "0-unstable-2025-10-24";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "d2608472d82ccc01c38db5eb8ef56a0a93212ebd";
    hash = "sha256-EZAGTnzbn8TA5D7rSe19ypFNu3/rfo/4NIScXu1g8Kg=";
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

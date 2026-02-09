{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "0-unstable-2026-02-09";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "50a9a2bdd042672048ddc254b69744d1dff69098";
    hash = "sha256-/eN2ErlNgfUf/Ns52c/gs+szUyegu1hrURuA+cUf3JU=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pkgs.pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/AquaNet";
    hash = "sha256-wHWYbn0Xe1SSXl7W/BxvW1sKdOu+CtAsX3fO7mgBlXc=";
    fetcherVersion = 2;
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

{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "47a171";
  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "47a171b1a4ac4ba7fea1f298d5ac5fa1cdf1d365";
    hash = "sha256-AEvpP5tBHgP2AZpLv9E6rEM5XWQhH/wDznHI2oTdzZ8=";
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

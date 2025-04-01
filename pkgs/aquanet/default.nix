{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "a6837f4";

  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "a6837f4555d2dfdcb093640a1e421ae5c721d0e0";
    hash = "sha256-/o/lHRuqeXQshU2AusyEDp01RyBIImk4ThvryRFSUrs=";
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
    cp ${./config.ts} $sourceRoot/AquaNet/src/libs/config.ts
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
  };
})

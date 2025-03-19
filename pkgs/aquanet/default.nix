{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aquanet";
  version = "1dcaddb";

  src = fetchFromGitHub {
    owner = "MewoLab";
    repo = "AquaDX";
    rev = "1dcaddb4c4136557127a9ea38f3516da70edc1f9";
    hash = "sha256-5PooG3RjmHtKG3Q2QQgKXUMK6UE+27RQhHjhco5l2ZE=";
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
    homepage = "https://github.com/MewoLab/AquaDX/tree/1dcaddb4c4136557127a9ea38f3516da70edc1f9/AquaNet";
    license = lib.licenses.cc-by-nc-sa-40;
  };
})

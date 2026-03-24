{
  lib,
  stdenvNoCC,
  installShellFiles,
  makeWrapper,
  nix,
  openssh,
}:
stdenvNoCC.mkDerivation {
  pname = "ndp";
  version = "1.0.0";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${./ndp} "$out/bin/ndp"
    installShellCompletion --bash --name ndp ${./ndp.bash}
    installShellCompletion --fish ${./ndp.fish}
    installShellCompletion --zsh ${./_ndp}

    mkdir -p "$out/nix-support"
    cat > "$out/nix-support/setup-hook" <<EOF
    addToSearchPath FPATH "$out/share/zsh/site-functions"
    EOF

    wrapProgram "$out/bin/ndp" \
      --prefix PATH : "${
        lib.makeBinPath [
          nix
          openssh
        ]
      }"

    runHook postInstall
  '';
}

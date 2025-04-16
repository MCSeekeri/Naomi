{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  openssl,
  jemalloc,
  sqlite,
  vulkan-loader,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "geph5";
  version = "0.2.43";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-v${finalAttrs.version}";
    hash = "sha256-Yn/oAUXNhKmgu1Xi2VvaOP+B4vnrn/lQQldXXtQiA3U=";
  };

  cargoHash = "sha256-lpWKzsgMSRg3BNdCyXn6b9HdGjndZF8YOoTIshz4BYU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    openssl
    jemalloc
    sqlite
    vulkan-loader
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "geph5-client"
  ];
  doCheck = false;

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Modular Internet censorship circumvention system designed specifically to deal with national filtering";
    homepage = "https://github.com/geph-official/geph5";
    changelog = "https://github.com/geph-official/geph5/releases/tag/geph5-client-v${finalAttrs.version}";
    mainProgram = "geph5-client";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ MCSeekeri ];
  };
})

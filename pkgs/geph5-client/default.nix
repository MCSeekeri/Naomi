{
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
rustPlatform.buildRustPackage rec {
  pname = "geph5";
  version = "v0.2.36";

  src = fetchFromGitHub {
    owner = "geph-official";
    repo = "geph5";
    rev = "geph5-client-${version}";
    hash = "sha256-c99l4gUAz6CnXCPywj7bnH5pFCkoJmAct25SX+24jQg=";
  };

  cargoHash = "sha256-QtPyVRkC1fpI/PaUOoo6jN5mgZ8s6TNoFia8YH3lRys=";

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
    description = "Geph is a modular Internet censorship circumvention system designed specifically to deal with national filtering. ";
    homepage = "https://github.com/geph-official/geph5";
    mainProgram = "geph5-client";
  };
}

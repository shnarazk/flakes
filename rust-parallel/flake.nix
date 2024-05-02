{
  description = "Fast command line app in rust/tokio to run commands in parallel. Similar interface to GNU parallel or xargs plus useful features. Listed in Awesome Rust utilities.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.listToAttrs (
        map
          (
            system: with import nixpkgs { inherit system; }; {
              name = system;
              value = {
                default = rustPlatform.buildRustPackage rec {
                  pname = "rust-parallel";
                  version = "1.18.0";

                  src = fetchFromGitHub {
                    owner = "aaronriekenberg";
                    repo = pname;
                    rev = "refs/tags/v${version}";
                    hash = "sha256-y9bTwpHn05/9929FjcENWIu6FgWBcvQ6JYV2MS1otv4=";
                  };

                  nativeBuildInputs = [
                    openssl
                    pkg-config
                    libgit2
                  ];
                  buildInputs = [
                    openssl
                    libgit2
                  ] ++ lib.optional stdenv.isDarwin [ iconv ];
                  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                  doCheck = false;
                  cargoHash = "sha256-a/KkK36FY4QEh5FjeCZGa3Vt/8DSdd2el6BDdUJB+90=";

                  meta = with lib; {
                    description = "Fast command line app in rust/tokio to run commands in parallel. Similar interface to GNU parallel or xargs plus useful features. Listed in Awesome Rust utilities.";
                    homepage = "https://github.com/aaronriekenberg/rust-parallel";
                    license = with licenses; [ mit ];
                    maintainers = with maintainers; [ shnarazk ];
                  };
                };
              };
            }
          )
          [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ]
      );
    };
}

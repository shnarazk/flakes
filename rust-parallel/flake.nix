{
  description = "Fast command line app in rust/tokio to run commands in parallel. Similar interface to GNU parallel or xargs plus useful features. Listed in Awesome Rust utilities.";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = rustPlatform.buildRustPackage rec {
                pname = "rust-parallel";
                version = "1.14.0-20240203";

                src = fetchFromGitHub {
                  owner = "aaronriekenberg";
                  repo = pname;
                  rev = "d841d9dac3f512e3f09715f82fc8111328f9418d";
                  hash = "sha256-uN7DqxWKOm9df8QjpkWAbja9QE2NbssHDIrHzSovZCs=";
                };

                nativeBuildInputs = [ openssl pkg-config libgit2 ];
                buildInputs = [ openssl libgit2 ] ++ lib.optional stdenv.isDarwin [iconv];
                PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                doCheck = false;
                cargoHash = "sha256-yn5fEUdlnlRJkIVyXPdrpX10M1mHzOL3c+dBkXp8SQY=";

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
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

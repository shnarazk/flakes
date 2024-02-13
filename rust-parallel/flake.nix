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
                version = "1.15.0";

                src = fetchFromGitHub {
                  owner = "aaronriekenberg";
                  repo = pname;
                  rev = "60bd880a89ccad27b5778c13e8c7106fe238cf3d";
                  hash = "sha256-3U/7RlS4kk0nydhJvNUkUWUTMVV61qsj2XNGrXUWhTM=";
                };

                nativeBuildInputs = [ openssl pkg-config libgit2 ];
                buildInputs = [ openssl libgit2 ] ++ lib.optional stdenv.isDarwin [iconv];
                PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                doCheck = false;
                cargoHash = "sha256-CA3fGSeekMw+fCRAuJ04bhkOYqK+PBcZxK8nJ7sqif4=";

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

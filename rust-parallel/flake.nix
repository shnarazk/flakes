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
                version = "1.16.1";

                src = fetchFromGitHub {
                  owner = "aaronriekenberg";
                  repo = pname;
                  rev = "refs/tags/v${version}";
                  hash = "sha256-z+u0eX5XfjdaqFt9Uszm3q/3Y3CkQUBL/M6zfin5g5w=";
                };

                nativeBuildInputs = [ openssl pkg-config libgit2 ];
                buildInputs = [ openssl libgit2 ] ++ lib.optional stdenv.isDarwin [iconv];
                PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                doCheck = false;
                cargoHash = "sha256-/emTrbt6mId/NPp67NWqIkUWC4WMgoqD89aa9t6MjDE=";

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

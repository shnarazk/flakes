{
  description = "Flake for tree-sitter-cli in Rust";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
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
                  pname = "tree-sitter-cli";
                  version = "0.24.4";

                  src = fetchFromGitHub {
                    owner = "tree-sitter";
                    repo = "tree-sitter";
                    rev = "refs/tags/v${version}";
                    hash = "sha256-DIlPEz8oTzLm5BZHPjIQCHDHUXdUhL+LRrkld11HzXw=";
                  };

                  # nativeBuildInputs = [];
                  buildInputs = [ ]
                    ++ lib.optional stdenv.isDarwin [
                      darwin.apple_sdk.frameworks.CoreServices
                    ];
                  # PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                  doCheck = false;
                  cargoHash = "sha256-AzJHBn2NZaDQEmEy/PVryj5XuEDvak7TQcbeO/R5S18=";
                  meta = with lib; {
                    description = "An incremental parsing system for programming toolstree-sitter-cli";
                    homepage = "https://tree-sitter.github.io/tree-sitter";
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

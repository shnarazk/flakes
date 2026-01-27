{
  description = "Flake for lean-tui - A TUI for Lean theorem prover";
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
                  pname = "lean-tui";
                  version = "0.1.0";

                  src = fetchCrate {
                    inherit pname version;
                    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                  };

                  buildInputs = [ ]
                    ++ lib.optional stdenv.isDarwin [
                      darwin.apple_sdk.frameworks.CoreServices
                      darwin.apple_sdk.frameworks.Security
                    ];
                  doCheck = false;
                  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
                  meta = with lib; {
                    description = "A TUI for Lean theorem prover";
                    homepage = "https://crates.io/crates/lean-tui";
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

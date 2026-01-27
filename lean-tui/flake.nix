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
                  version = "0.0.8";

                  src = fetchCrate {
                    inherit pname version;
                    hash = "sha256-FLsc1ZhLKwc6218fNBJDcA1Ms2s37qkxCFzGZ91LHEU=";
                  };

                  buildInputs = [ ];
                  doCheck = false;
                  cargoHash = "sha256-O9mU29XHPbtTl8TxHZzGGUsifps2heNpiZLAPhH/65U=";
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

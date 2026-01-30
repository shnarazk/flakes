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
                  version = "0.0.10";

                  src = fetchCrate {
                    inherit pname version;
                    hash = "sha256-4MJPA5UHMRpGeMB2ZHN2rtNAi9TGcfdtrv/TUQOPQmE=";
                  };

                  buildInputs = [ ];
                  doCheck = false;
                  cargoHash = "sha256-sXybavtkT/hBWpicY0w4YOfKKo6NWsGfhytLAF0W0K0=";
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

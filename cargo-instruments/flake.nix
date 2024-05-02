{
  description = "Easily profile your rust crate with Xcode [Instruments]";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.listToAttrs (
        map
          (
            system: with import nixpkgs { system = "${system}"; }; {
              name = system;
              value = {
                default = stdenv.mkDerivation rec {
                  name = "cargo-instruments-${version}";
                  pname = "cargo-instruments";
                  version = "0.4.4";
                  src = fetchFromGitHub {
                    owner = "cmyr";
                    repo = "cargo-instruments";
                    rev = "b166c98aec9313df830e8f016ffbfac99ef8b42c";
                    # nix flake prefetch https://github.com/cmyr/cargo-instruments/archive/${rev}.tar.gz
                    sha256 = "sha256-y06j1rJ1TUtZvlMNQWCeRie73sTnoABTXeFnJzALibg=";
                  };
                  buildInputs = rustc.buildInputs ++ [
                    cargo
                    rustc
                    pkg-config
                  ];
                  buildPhase = "cargo build --release";
                  installPhase = "mkdir -p $out/bin; install -t $out/bin target/release/cargo-instruments";
                };
              };
            }
          )
          [
            "aarch64-darwin"
            "x86_64-darwin"
          ]
      );
    };
}

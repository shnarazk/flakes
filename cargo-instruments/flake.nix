{
  description = "Easily profile your rust crate with Xcode [Instruments]";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem ["aarch64-darwin" "x86_64-darwin"] (system: {
      defaultPackage =
        with import nixpkgs { system = "${system}"; };
        stdenv.mkDerivation rec {
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

          buildInputs = rustc.buildInputs ++ [ cargo rustc pkgconfig ];
          buildPhase = "cargo build --release";
          installPhase = "mkdir -p $out/bin; install -t $out/bin target/release/cargo-instruments";
        }
      ;
    })
  ;
}

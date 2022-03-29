{
  description = "Piling up my flakes";
  inputs = {
    flake-utils.url       = github:numtide/flake-utils;
    cadical.url           = github:shnarazk/flakes?dir=cadical;
    cargo-instruments.url = github:shnarazk/flakes?dir=cargo-instruments;
    emacs-head.url        = github:shnarazk/flakes?dir=emacs-head;
    fukuoka-c19.url       = github:shnarazk/fukuoka-c19.rs;
    gratchk.url           = github:shnarazk/flakes?dir=gratchk;
    gratgen.url           = github:shnarazk/flakes?dir=gratgen;
    sat-bench.url         = github:shnarazk/SAT-bench;
    splr.url              = github:shnarazk/splr;
  };
  outputs = { self, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          cadical           = inputs.cadical.${system}.default;
          emacs-head        = inputs.emacs-head.${system}.default;
          fukuoka-c19       = inputs.fukuoka-c19.${system}.default;
          gratgen           = inputs.gratgen.${system}.default;
          sat-bench         = inputs.sat-bench.${system}.default;
          splr              = inputs.splr.${system}.default;
        }
        // (
          if system == "x86_64-darwin" then { # || system == "aarch64-darwin"
            cargo-instruments = inputs.cargo-instruments.${system}.default;
            gratchk           = inputs.gratchk.${system}.default;
          } else {
          });
      }
    );
}
 

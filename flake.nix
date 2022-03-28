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
          cadical           = inputs.cadical.defaultPackage.${system};
          emacs-head        = inputs.emacs-head.defaultPackage.${system};
          fukuoka-c19       = inputs.fukuoka-c19.defaultPackage.${system};
          gratgen           = inputs.gratgen.defaultPackage.${system};
          sat-bench         = inputs.sat-bench.defaultPackage.${system};
          splr              = inputs.splr.defaultPackage.${system};
        }
        // (
          if system == "x86_64-darwin" then { # || system == "aarch64-darwin"
            cargo-instruments = inputs.cargo-instruments.defaultPackage.${system};
            gratchk           = inputs.gratchk.defaultPackage.${system};
          } else {
          });
      }
    );
}
 

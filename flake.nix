{
  description = "Piling up my flakes";
  inputs = {
    flake-utils.url       = github:numtide/flake-utils;
    cadical.url           = github:shnarazk/flakes?dir=cadical;
    cargo-instruments.url = github:shnarazk/flakes?dir=cargo-instruments;
    emacs-head.url        = github:shnarazk/flakes?dir=emacs-head;
    fukuoka-covid19.url   = github:shnarazk/learn-dioxus;
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
          cargo-instruments = inputs.cargo-instruments.defaultPackage.${system};
          emacs-head        = inputs.emacs-head.defaultPackage.${system};
          fukuoka-covid19   = inputs.fukuoka-covid19.defaultPackage.${system};
          gratchk           = inputs.gratchk.defaultPackage.${system};
          gratgen           = inputs.gratgen.defaultPackage.${system};
          sat-bench         = inputs.sat-bench.defaultPackage.${system};
          splr              = inputs.splr.defaultPackage.${system};
        };
      }
    );
}

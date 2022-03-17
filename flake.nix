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
    helix.url             = github:shnarazk/helix;
    sat-bench.url         = github:shnarazk/SAT-bench;
    splr.url              = github:shnarazk/splr;
    tmux.url              = github:shnarazk/flakes?dir=tmux;
  };
  outputs = { self, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          cadical           = inputs.cadical.defaultPackage.${system};
          emacs-head        = inputs.emacs-head.defaultPackage.${system};
          fukuoka-c19       = inputs.fukuoka-c19.defaultPackage.${system};
          gratgen           = inputs.gratgen.defaultPackage.${system};
          # helix             = inputs.helix.defaultPackage.${system};
          sat-bench         = inputs.sat-bench.defaultPackage.${system};
          splr              = inputs.splr.defaultPackage.${system};
          tmux              = inputs.splr.defaultPackage.${system};
        }
        // (
          if system == "x86_64-darwin" || system == "aarch64-darwin" then {
            cargo-instruments = inputs.cargo-instruments.defaultPackage.${system};
            gratchk           = inputs.gratchk.defaultPackage.${system};
            helix             = inputs.helix.defaultPackage.${system};
          } else {
          });
      }
    );
}
 

{
  description = "Piling up my flakes";
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    emacs-head.url  = github:shnarazk/flakes?dir=emacs-head;
    kissat.url      = github:shnarazk/flakes?dir=kissat;
    sat-bench.url   = github:shnarazk/SAT-bench;
    splr.url        = github:shnarazk/splr;
  };
  outputs = { self, flake-utils, emacs-head, kissat, sat-bench, splr }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          emacs-head = emacs-head.defaultPackage.${system};
          kissat     = kissat.defaultPackage.${system};
          sat-bench  = sat-bench.defaultPackage.${system};
          splr       = splr.defaultPackage.${system};
        };
      }
    );
}

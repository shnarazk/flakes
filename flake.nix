{
  description = "Piling up my flakes";
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    cadical.url     = github:shnarazk/flakes?dir=cadical;
    emacs-head.url  = github:shnarazk/flakes?dir=emacs-head;
    gratchk.url     = github:shnarazk/flakes?dir=gratchk;
    gratgen.url     = github:shnarazk/flakes?dir=gratgen;
    kissat.url      = github:shnarazk/flakes?dir=kissat;
    sat-bench.url   = github:shnarazk/SAT-bench;
    splr.url        = github:shnarazk/splr;
  };
  outputs = { self, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          cadical    = inputs.cadical.defaultPackage.${system};
          emacs-head = inputs.emacs-head.defaultPackage.${system};
          gratchk    = inputs.gratchk.defaultPackage.${system};
          gratgen    = inputs.gratgen.defaultPackage.${system};
          kissat     = inputs.kissat.defaultPackage.${system};
          sat-bench  = inputs.sat-bench.defaultPackage.${system};
          splr       = inputs.splr.defaultPackage.${system};
        };
      }
    );
}

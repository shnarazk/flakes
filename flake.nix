{
  description = "Piling up my flakes";
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    emacs-head.url = "./emacs-head";
    kissat.url = "./kissat";
  };
  outputs = { self, flake-utils, emacs-head, kissat }:
    flake-utils.lib.eachDefaultSystem (system:
      {
        packages = {
          emacs-head = emacs-head.defaultPackage.${system};
          kissat = kissat.defaultPackage.${system};
        };
      }
    );
}

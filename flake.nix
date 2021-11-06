{
  description = "piling my flakes";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.emacs-head.url = "./emacs-head";
  inputs.kissat.url = "./kissat";
  outputs = { self, nixpkgs, flake-utils, emacs-head, kissat }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = {
          emacs-head = emacs-head.defaultPackage.${system};
          kissat = kissat.defaultPackage.${system};
        };
      }
    );
}

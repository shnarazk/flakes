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
    splr.url              = github:shnarazk/splr?ref=exp-penetration-enegry-20220321;
  };
  outputs = { self, flake-utils, ... }@inputs:
    flake-utils.lib.eachSystem
      [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      (system:
        {
          packages = {
            cadical           = inputs.cadical.packages.${system}.default;
            emacs-head        = inputs.emacs-head.packages.${system}.default;
            fukuoka-c19       = inputs.fukuoka-c19.packages.${system}.default;
            # gratgen           = inputs.gratgen.packages.${system}.default;
            sat-bench         = inputs.sat-bench.packages.${system}.default;
            splr              = inputs.splr.packages.${system}.default;
          };
          # // (
          #   if system == "x86_64-darwin" then { # || system == "aarch64-darwin"
          #     cargo-instruments = inputs.cargo-instruments.${system}.default;
          #     gratchk           = inputs.gratchk.${system}.default;
          #   } else {
          #   });
        }
      )
    ;
}
 

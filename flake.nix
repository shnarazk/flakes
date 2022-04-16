{
  description = "Piling up my flakes";
  inputs = {
    cadical.url           = github:shnarazk/flakes?dir=cadical;
    cargo-instruments.url = github:shnarazk/flakes?dir=cargo-instruments;
    emacs-head.url        = github:shnarazk/flakes?dir=emacs-head;
    fukuoka-c19.url       = github:shnarazk/fukuoka-c19.rs;
    gratchk.url           = github:shnarazk/flakes?dir=gratchk;
    gratgen.url           = github:shnarazk/flakes?dir=gratgen;
    nushell.url           = github:shnarazk/flakes?dir=nushell;
    sat-bench.url         = github:shnarazk/SAT-bench;
    splr.url              = github:shnarazk/splr?ref=exp-penetration-enegry-20220321;
  };
  outputs = inputs: {
    packages = builtins.listToAttrs
      (map
        (system:
          {
            name = system;
            value = {
              cadical     = inputs.cadical.packages.${system}.default;
              emacs-head  = inputs.emacs-head.packages.${system}.default;
              fukuoka-c19 = inputs.fukuoka-c19.packages.${system}.default;
              gratgen     = inputs.gratgen.packages.${system}.default;
              nushell     = inputs.nushell.packages.${system}.default;
              sat-bench   = inputs.sat-bench.packages.${system}.default;
              splr        = inputs.splr.packages.${system}.default;
            } // (if system == "x86_64-darwin" || system == "x86_64-linux" then {
              gratchk      = inputs.gratchk.packages.${system}.default;
            } else {
            }) // (if system == "x86_64-darwin" || system == "aarch64-darwin" then {
               cargo-instruments = inputs.cargo-instruments.packages.${system}.default;
             } else {
             })
            ;
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}
 

{
  description = "Piling up my flakes";
  inputs = {
    alacritty-head.url    = github:shnarazk/flakes?dir=alacritty-head;
    cargo-instruments.url = github:shnarazk/flakes?dir=cargo-instruments;
    cbqn.url              = github:shnarazk/flakes?dir=cbqn;
    emacs-head.url        = github:shnarazk/flakes?dir=emacs-head;
    fukuoka-c19.url       = github:shnarazk/fukuoka-c19.rs;
    gratchk.url           = github:shnarazk/flakes?dir=gratchk;
    gratgen.url           = github:shnarazk/flakes?dir=gratgen;
    mypython10.url        = github:shnarazk/flakes?dir=python;
    sat-bench.url         = github:shnarazk/SAT-bench;
    splr.url              = github:shnarazk/splr;
  };
  outputs = inputs: {
    packages = builtins.listToAttrs
      (map
        (system:
          {
            name = system;
            value = {
              alacritty-head     = inputs.alacritty-head.packages.${system}.default;
              cbqn               = inputs.cbqn.packages.${system}.default;
              emacs-head         = inputs.emacs-head.packages.${system}.default;
              fukuoka-c19        = inputs.fukuoka-c19.packages.${system}.default;
              gratgen            = inputs.gratgen.packages.${system}.default;
              sat-bench          = inputs.sat-bench.packages.${system}.default;
              mypython10         = inputs.mypython.packages.${system}.default;
              splr               = inputs.splr.packages.${system}.default;
            } // (if system == "x86_64-darwin" || system == "x86_64-linux" then {
              gratchk            = inputs.gratchk.packages.${system}.default;
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
 

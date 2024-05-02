{
  description = "Piling up my flakes";
  inputs = {
    alacritty-head.url = "github:shnarazk/flakes?dir=alacritty-head";
    # bqnlsp.url            = github:shnarazk/bqnlsp/20230507-flake;
    # bqnlsp.url            = sourcehut:~detegr/bqnlsp;
    # cargo-instruments.url = github:shnarazk/flakes?dir=cargo-instruments;
    # cbqn-head.url         = github:shnarazk/flakes?dir=cbqn-head;
    # emacs-head.url        = github:shnarazk/flakes?dir=emacs-head;
    # fukuoka-c19.url       = github:shnarazk/fukuoka-c19.rs;
    # gex-head.url          = github:shnarazk/flakes?dir=gex-head;
    gratchk.url = "github:shnarazk/flakes?dir=gratchk";
    gratgen.url = "github:shnarazk/flakes?dir=gratgen";
    sat-bench.url = "github:shnarazk/SAT-bench";
    rust-parallel.url = "github:shnarazk/flakes?dir=rust-parallel";
    splr.url = "github:shnarazk/splr";
    zellij-head.url = "github:shnarazk/flakes?dir=zellij-head";
  };
  outputs = inputs: {
    packages = builtins.listToAttrs (
      map
        (system: {
          name = system;
          value =
            {
              alacritty-head = inputs.alacritty-head.packages.${system}.default;
              # bqnlsp             = inputs.bqnlsp.packages.${system}.default;
              # cbqn-head          = inputs.cbqn-head.packages.${system}.default;
              # emacs-head         = inputs.emacs-head.packages.${system}.default;
              # fukuoka-c19        = inputs.fukuoka-c19.packages.${system}.default;
              # gex-head           = inputs.gex-head.packages.${system}.default;
              gratgen = inputs.gratgen.packages.${system}.default;
              sat-bench = inputs.sat-bench.packages.${system}.default;
              rust-parallel = inputs.rust-parallel.packages.${system}.default;
              splr = inputs.splr.packages.${system}.default;
              zellij-head = inputs.zellij-head.packages.${system}.default;
            }
            // (
              if system == "x86_64-darwin" || system == "x86_64-linux" then
                { gratchk = inputs.gratchk.packages.${system}.default; }
              else
                { }
            )
          # // (if system == "x86_64-darwin" || system == "aarch64-darwin" then {
          #  cargo-instruments = inputs.cargo-instruments.packages.${system}.default;
          # } else {
          # })
          ;
        })
        [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ]
    );
  };
}

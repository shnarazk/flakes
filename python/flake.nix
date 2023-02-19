{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    # overlays = {
    #   default = final: prev: {
    #     mypython = prev.python310Full.override {
    #       withPackages = (ps: [ ps.scikit-learn ]);
    #     };
    #   };
    # };
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = { default = python310.withPackages(ps: 
              [
                ps.jupyterlab
                ps.matplotlib
                ps.numpy
                ps.pillow
                ps.python-lsp-server
                ps.scipy
                ps.scikit-learn
                ps.tkinter
              ]);
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}


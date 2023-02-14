{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    # overlays = {
    #   default = final: prev: {
    #     python311Full = prev.python311Full.override {
    #       withPackages = (ps: [ ps.sckit-learn ]);
    #     };
    #   };
    # };
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = { default = python311Full; };
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}


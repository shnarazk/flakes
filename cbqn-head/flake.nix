{
  description = "A BQN implementation in C";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    # overlays = {
    #   default = final: prev: {
    #     cbqn-head = prev.cbqn-head.override {
    #       enableReplxx = true;
    #     };
    #   };
    # };
    overlays.default = {
      enableReplxx = true;
    };
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = cbqn.overrideAttrs (attrs: rec {
                pname = "cbqn-head";
                version = "0.2.0";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "dzaima";
                  repo = "CBQN";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-M9GTsm65DySLcMk9QDEhImHnUvWtYGPwiG657wHg3KA=";
                };
              });
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

{
  description = "Zellij overlay to zellij-0.35.1";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = zellij.overrideAttrs (attrs: rec {
                pname = "zellij-head";
                version = "0.35.1";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "zellij-org";
                  repo = "zellij";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-ntLEZDUCnEliehq2/NN7cLO2E7bh1RxXVTdzMt8jee4=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = zellij.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-eHbCDbR2w7g984N5zaHbvQeA+nEJeg7IPbm+1Oa7mTM=";
                });
              });
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

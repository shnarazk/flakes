{
  description = "Alacritty overlay to Head, the unreleased 0.10.2";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    # overlays = {
    #   default = final: prev: {
    #     alacritty-head = prev.alacritty-head.override {
    #       # cargoSha256 = "0000000000000000000000000000000000000000000000000000";
    #       # cargoSha256 = null;
    #       cargoDeps = {};
    #       version = "0.12.0";
    #     };
    #   };
    # };
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = alacritty.overrideAttrs (attrs: rec {
                pname = "alacritty-head";
                version = "0.11.0-rc2";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "alacritty";
                  repo = "alacritty";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-svo7DIPgNQy+MkIrRtRQjKQ2ND0CRfofSCiXJqoWby0=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-AyRsxT+4TdRdtKrodK+7N+Y/UkeA67OepnMLIpK1WR8=";
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

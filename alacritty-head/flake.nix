{
  description = "Alacritty overlay to Head, the released 0.12.3RC1";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = alacritty.overrideAttrs (attrs: rec {
                pname = "alacritty-head";
                version = "0.12.3-rc1";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "alacritty";
                  repo = "alacritty";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-tGqWv/O1DV3vRTdlu22rQ0jIVeTzDr62Bm9lHA4+0B8=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-BZ8fMr/QlWx/sE16n5qv5V/QYTsxC5p5Ky3iQsMdhP0=";
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

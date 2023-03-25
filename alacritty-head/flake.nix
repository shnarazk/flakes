{
  description = "Alacritty overlay to Head, the released 0.12.0";
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
                version = "0.12.0";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "alacritty";
                  repo = "alacritty";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-2MiFsOZpAlDVC4h3m3HHlMr2ytL/z47vrTwUMoHdegI=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-WqatkYGqyO2PSHX2wkv5BiqF5rFat/OSnaoJkdo4/kA=";
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

{
  description = "Alacritty overlay to Head, the unreleased 0.12.0";
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
                version = "0.12.0-rc2";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "alacritty";
                  repo = "alacritty";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-ul1Wh6ILU8hDmW0OB6aTYYceCiSIbfGbrvfyiksWGyo=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-oF3DIOSilVmRoGqxelX4FfNyaB+x2j3VhwyzNadi8JI=";
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

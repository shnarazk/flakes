{
  description = "Zellij overlay to zellij-0.35.2";
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
                version = "0.35.2";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "zellij-org";
                  repo = "zellij";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-2wgv84Qm/X5mcEcM5ch7tFHZVg/xassUOtssSzbr0fs=";
                };
                cargoDeps = zellij.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-ycKCU5tEqefgwXQlyACCoYOEayccqRifc1KjFcTgf3A=";
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

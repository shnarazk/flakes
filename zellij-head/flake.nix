{
  description = "Zellij head";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.listToAttrs (
        map
          (
            system: with import nixpkgs { inherit system; }; {
              name = system;
              value = {
                default = zellij.overrideAttrs (attrs: rec {
                  pname = "zellij-head";
                  version = "0.41.1";
                  name = "${pname}-${version}";
                  src = fetchFromGitHub {
                    owner = "zellij-org";
                    repo = "zellij";
                    rev = "refs/tags/v${version}";
                    sha256 = "sha256-EUoJHM0Jm0uFKFeHhtzon/ZRC615SHfYa1gr4RnCNBw=";
                  };
                  buildInputs = zellij.buildInputs ++ [
                    curl
                    openssh
                    pkg-config
                    perl
                  ];
                  nativeBuildInputs = zellij.nativeBuildInputs ++ [
                    openssh
                    pkg-config
                    perl
                  ];
                  cargoDeps = zellij.cargoDeps.overrideAttrs (
                    lib.const {
                      name = "${pname}-vendor.tar.gz";
                      inherit src;
                      outputHash = "sha256-RX94a3LQ+d71TJDi+Wfl6P4xkhIBcCaOqbKIvSt3FeE=";
                    }
                  );
                });
              };
            }
          )
          [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ]
      );
    };
}

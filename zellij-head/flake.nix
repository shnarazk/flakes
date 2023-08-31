{
  description = "Zellij head";
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
                version = "0.38.1";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "zellij-org";
                  repo = "zellij";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-3khMo5qMG0qonMnPvuErVYFohUrZLAkaxKZzkMHou8E=";
                };
                cargoDeps = zellij.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-kjEbmyB2atvT+MsBQOWYhKwi7428e48gSMGxPwY6/RY=";
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

{
  description = "Git Explorer:cross-platform git workflow improvement tool inspired by Magit";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = rustPlatform.buildRustPackage rec {
                pname = "gex";
                version = "0.3.8";

                src = fetchFromGitHub {
                  owner = "Piturnah";
                  repo = pname;
                  rev = "v${version}";
                  hash = "sha256-pjyS0H25wdcexpzZ2vVzGTwDPzyvA9PDgzz81yLGTOY=";
                };

                nativeBuildInputs = [ openssl pkg-config libgit2 ];
                buildInputs = [ openssl libgit2 ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
                PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";
                cargoHash = "sha256-+FwXm3QN9bt//dWqzkBzsGigyl1SSY4/P29QtV75V6M=";

                meta = with lib; {
                  description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
                  homepage = "https://github.com/Piturnah/gex";
                  license = with licenses; [ asl20 /* or */ mit ];
                  maintainers = with maintainers; [ Br1ght0ne shnarazk ];
                };
              };
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

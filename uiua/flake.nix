{
  description = "A stack-based array programming laguage";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }:
  {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { system = "${system}"; };
          {
            name = system;
            value = {
              default =
                stdenv.mkDerivation rec {
                  name = "uiua-${version}";
                  pname = "uiua";
                  version = "0.0.2-20230930";
                  src = fetchFromGitHub {
                    owner = "uiua-lang";
                    repo = "uiua";
                    # rev = "refs/tags/v${version}";
                    rev = "81420e00c59fdbcd37576d11a61b059998788381";
                    sha256 = "sha256-zcGBjamknEVIcM2I15AtubGU4ixIrxUHUoNWTkQ5a+g=";
                  };
                  buildInputs = rustc.buildInputs ++ [ cargo rustc pkg-config cacert ]
                     ++ lib.optionals stdenv.isDarwin [
                        darwin.apple_sdk.frameworks.CoreServices
                      ];
                  buildPhase = ''
                    cargo build --release
                  '';
                  # buildPhase = ''
                  #   cargo build --release --features "binary"
                  # '';
                  installPhase = ''
                    mkdir -p $out/bin
                    install -t $out/bin target/release/uiua
                  '';
                };
            };
          })
      [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
    );
  };
}

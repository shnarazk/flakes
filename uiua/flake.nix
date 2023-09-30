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
                  version = "0.0.3-20230930";
                  src = fetchFromGitHub {
                    owner = "uiua-lang";
                    repo = "uiua";
                    # rev = "refs/tags/v${version}";
                    rev = "f5fe5edb4c41b23669763bf47c8c2b939eb9740d";
                    sha256 = "sha256-SWMPtT3+HH61Wa8QQrFmt31aW8Aa2mgbltNuU1VTrv8=";
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

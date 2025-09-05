{
  description = "Monaspace static fonts";
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
                default = monaspace.overrideAttrs (attrs: rec {
                  version = "1.301";
                  name = "monaspace-${version}";
                  src = fetchzip {
                    url = "https://github.com/githubnext/monaspace/releases/download/v${version}/monaspace-static-v${version}.zip";
                    stripRoot = false;
                    hash = "sha256-H6J4InGyXabZuslywuzNYqw14zymzF90JKxa7CikOIM=";
                  };
                  outputs = [ "out" ];

                  installPhase = ''
                    runHook preInstall
                    install -Dm644 Static\ Fonts/*/*.otf -t $out/share/fonts/opentype
                    runHook postInstall
                  '';
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

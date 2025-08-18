{
  description = "Julia-bin without tests";
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
                default = julia-bin.overrideAttrs (attrs: {
                  doInstallCheck = false;
                  installCheckPhase = ''
                    runHook preInstallCheck
                    # Command lifted from `test/Makefile`.
                    $out/bin/julia \
                      --check-bounds=yes \
                      --startup-file=no \
                      --depwarn=error \
                    runHook postInstallCheck
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

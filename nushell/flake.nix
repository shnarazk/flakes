{
  description = "The latest Nu shell";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }:
    {
      packages = builtins.listToAttrs
        (map
          (system:
            with import nixpkgs { inherit system; };
            {
              name = system;
              value = {
                default = nushell.overrideAttrs (attrs: rec {
                    pname = "nushell";
                    version = "0.61.0";
                    src = fetchFromGitHub {
                        owner = pname;
                        repo = pname;
                        rev = "0.61.0";
                        sha256 = "sha256-1wTMXlFViJh/x+W7WqZ9uf1SV6X4er6SWO6qTjf9C94=";
                    };
                    cargoSha256 = "0000000000000000000000000000000000000000000000000000";
                });
              };
            })
          [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
        );
    };
}

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
                    version = "0.61.0-20220416-1";
                    rev = "3783c19d02f4a3b2f35cd26b79daabcb70b04880";
                  });
              };
            })
          [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
        );
    };
}

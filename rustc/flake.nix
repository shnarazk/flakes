{
  description = "Emacs Head, the unreleased 28.0";
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
                default = let
                  emacsNative = emacs27.override {
                    nativeComp = true;
                  };
                in
                  rustc.overrideAttrs (attrs: rec {
                    version = "1.59";
                    rev = "1bef52ce73d61c827677edde60639fd2b8d74d92";
                    patches = [];
                  });
              };
            })
          [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
        );
    };
}

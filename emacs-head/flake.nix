{
  description = "Emacs Head, the unreleased 29.1";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    overlays = {
      default = final: prev: {
        emacs-head = prev.emacs-head.override {
          nativeComp = true;
          withTreeSitter = true;
        };
      };
    };
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = emacs.overrideAttrs (attrs: rec {
                  pname = "emacs-head";
                  version = "29.0.90-1";
                  name = "emacs-head-${version}";
                  rev = "a44d906740f0d8b2bf11b4db4f1cce88f4382692";
                  src = fetchurl {
                    url = "https://alpha.gnu.org/gnu/emacs/pretest/emacs-29.0.90.tar.xz";
                    sha256 = "sha256-oUf6XX09Yh0k1V+lY9vx9M6UBUW1x00TiuANDDs1ZrY=";
                  };
                }
              );
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

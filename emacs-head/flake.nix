{
  description = "Emacs Head, the unreleased 29.1";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    overlays = {
      default = final: prev: {
        emacs-head = prev.emacs-head.override {
          nativeComp = false;
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
              default = let
                emacsNative = emacs28.override {
                  nativeComp = false;
                  withTreeSitter = true;
                };
              in
                emacsNative.overrideAttrs (attrs: rec {
                  name = "emacs-head-${version}";
                  pname = "emacs-head";
                  version = "29.0.90-1";
                  rev = "a44d906740f0d8b2bf11b4db4f1cce88f4382692";
                  src = fetchurl {
                    url = "https://alpha.gnu.org/gnu/emacs/pretest/emacs-29.0.90.tar.xz";
                    sha256 = "sha256-oUf6XX09Yh0k1V+lY9vx9M6UBUW1x00TiuANDDs1ZrY=";
                  };
                  patches = [];
                  preConfigure = ''
                    ./autogen.sh
                  '' + ''
                    substituteInPlace lisp/international/mule-cmds.el \
                      --replace /usr/share/locale ${gettext}/share/locale
                         for makefile_in in $(find . -name Makefile.in -print); do
                        substituteInPlace $makefile_in --replace /bin/pwd pwd
                    done
                  '';
                  # configureFlags = emacsNative.configureFlags ++ ["--with-native-compilation" "--with-tree-sitter"];
                  # buildInputs = emacsNative.buildInputs
                  #               ++ [ autoconf automake texinfo gcc libgccjit zlib ]
                  #               ++ lib.optionals stdenv.isDarwin (
                  #                 with darwin.apple_sdk.frameworks; [
                  #                   AppKit Carbon Cocoa GSS ImageIO ImageCaptureCore
                  #                   IOKit OSAKit Quartz QuartzCore WebKit
                  #                 ]);
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

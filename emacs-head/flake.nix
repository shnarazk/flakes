{
  description = "Emacs Head, the unreleased 28.2";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    overlays = {
      default = final: prev: {
        emacs-head = prev.emacs-head.override {
          nativeComp = true;
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
                  nativeComp = true;
                };
              in
                emacsNative.overrideAttrs (attrs: rec {
                  name = "emacs-head-${version}";
                  pname = "emacs-head";
                  version = "28.2-20220913-1";
                  rev = "6a35160e557120b27ee6f8da04c50a89ee54b28c";
                  src = fetchurl {
                    url = "https://ftpmirror.gnu.org/emacs/emacs-28.2.tar.xz";
                    sha256 = "ee21182233ef3232dc97b486af2d86e14042dbb65bbc535df562c3a858232488";
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
                  configureFlags = emacsNative.configureFlags ++ ["--with-native-compilation"];
                  buildInputs = emacsNative.buildInputs
                                ++ [ autoconf automake texinfo gcc libgccjit zlib ]
                                ++ lib.optionals stdenv.isDarwin (
                                  with darwin.apple_sdk.frameworks; [
                                    AppKit Carbon Cocoa GSS ImageIO ImageCaptureCore
                                    IOKit OSAKit Quartz QuartzCore WebKit
                                  ]);
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

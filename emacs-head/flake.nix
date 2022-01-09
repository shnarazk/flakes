{
  description = "Emacs Head, the unreleased 28.0";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      overlay = self: prev: {
        emacs-head = prev.emacs-head.override {
          nativeComp = true;
        };
      };
      defaultPackage =
        with import nixpkgs { inherit system; };
        let
          emacsNative = emacs27.override {
            nativeComp = true;
          };
        in
          emacsNative.overrideAttrs (attrs: rec {
            name = "emacs-head-${version}";
            pname = "emacs-head";
            version = "28.0.91-20220109-1";
            rev = "c54fda643d4407aed729a6a84fdd28c69373580b";
            src = fetchurl {
              url = "https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-${rev}.tar.gz";
              # nix flake prefetch ${url}
              # nix-prefetch-url --type sha256 --unpack $url
              sha256 = "sha256-CnwLskCMv0lI/noSyiy373GOOSx6Jz2KVcZKVS/bukQ=";
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
          });
    });
}

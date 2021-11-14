{
  description = "Emacs Head, the unreleased 28.0";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
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
            version = "28.0.60-20211114";
            rev = "d4536ff2572931b105198a85a452a777d6d3a1ff";
            src = fetchurl {
              url = "https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-${rev}.tar.gz";
              # nix-prefetch-url --type sha256 ${url}
              sha256 = "00l1rczh3scfimh8s70a5z8adaddhg1whl76za5i9w361bk9nxq5";
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

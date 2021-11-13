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
            version = "28.0.60-20211113";
            rev = "42d4e24ff3f13ccbd401d93d70ecdee99b88a26d";
            src = fetchurl {
              url = "https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-${rev}.tar.gz";
              # nix-prefetch-url --type sha256 ${url}
              sha256 = "15anma0c9bxww9hns4nciinbs2yv2sjcnb5nlzsw1cwci93mrf9z";
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
            configureFlags = emacs27.configureFlags ++ ["--with-native-compilation"];
            buildInputs = emacs27.buildInputs
                          ++ [ autoconf automake texinfo gcc libgccjit zlib ]
                          ++ lib.optionals stdenv.isDarwin (
                            with darwin.apple_sdk.frameworks; [
                              AppKit Carbon Cocoa GSS ImageIO ImageCaptureCore
                              IOKit OSAKit Quartz QuartzCore WebKit
                            ]);
          });
    });
}

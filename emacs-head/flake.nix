{
  description = "Emacs Head, the unreleased 28.0";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        with import nixpkgs { inherit system; };
        emacs27 // rec {
        # emacs27.overrideAttrs (attrs: rec {
          nativeComp = true;
          name = "emacs-head-${version}";
          pname = "emacs-head";
          version = "28.0.60-20211112-2";
          src = fetchFromGitHub {
            owner = "emacs-mirror";
            repo = "emacs";
            rev = "0d0125daaeb77af5aa6091059ff6d0c1ce9f6cff";
            sha256 = "1q3gpa03pwgl1ry51m1ldxryna2g0xmy62vxnlxrkiqdkl7ikc3v";
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
          buildInputs = emacs27.buildInputs
                        ++ [ autoconf automake texinfo gcc libgccjit ]
                        ++ lib.optionals stdenv.isDarwin (
                          with darwin.apple_sdk.frameworks; [
                            AppKit Carbon Cocoa GSS ImageIO ImageCaptureCore
                            IOKit OSAKit Quartz QuartzCore WebKit
                          ]);
        });
    });
}

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
        emacs27.overrideAttrs (attrs: rec {
          name = "emacs-head-${version}";
          pname = "emacs-head";
          version = "28.0.60-20211112";
          src = fetchFromGitHub {
            owner = "emacs-mirror";
            repo = "emacs";
            rev = "6dae01ad6da1bcbced062c0d46a6759c7a0570e4";
            sha256 = "1xy91qs6gzl05fpqsxq50p3picw5n4awizm1rbj7ya01zj1adkma";
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
          nativeBuildInputs = [ pkgconfig autoconf automake texinfo ];
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

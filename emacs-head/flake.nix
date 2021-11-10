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
          version = "28.0.60-${src.rev}";
          src = fetchFromGitHub {
            owner = "emacs-mirror";
            repo = "emacs";
            rev = "2963de6540a1dc57399eaf530d8e12c794137a84";
            #sha256 = "1111111111111111111111111111111111111111111111111111";
            sha256 = "sha256-VfX3A8/B+OTCAi76JmjlNcGHcNaBuKVSNADNDNzQW9E=";
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
          nativeBuildInputs = [ pkgconfig autoconf automake texinfo ];
          buildInputs = emacs27.buildInputs
                        ++ [ autoconf automake texinfo ]
                        ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit darwin.apple_sdk.frameworks.Carbon darwin.apple_sdk.frameworks.Cocoa darwin.apple_sdk.frameworks.IOKit darwin.apple_sdk.frameworks.OSAKit darwin.apple_sdk.frameworks.Quartz darwin.apple_sdk.frameworks.QuartzCore darwin.apple_sdk.frameworks.WebKit darwin.apple_sdk.frameworks.ImageCaptureCore darwin.apple_sdk.frameworks.GSS darwin.apple_sdk.frameworks.ImageIO ];
        });
    });
}

{
  description = "Emacs Head, the unreleased 28.2";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }:
    {
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
            with import nixpkgs { inherit system; };
            {
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
                    version = "28.1.91-20220813-1";
                    rev = "9b348d1d67135b3155a200e0c4d49f0092f52e03";
                    src = fetchurl {
                      url = "https://alpha.gnu.org/gnu/emacs/pretest/emacs-28.1.91.tar.xz";
                      sha256 = "sha256-FfZLrqHfDZT51BE/tFcLumb0xaeTkVfbYnYsmOWarZ4=";
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
              };
            })
          [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
        );
    };
}

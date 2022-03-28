{
  description = "Emacs Head, the unreleased 28.0";
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
                  emacsNative = emacs27.override {
                    nativeComp = true;
                  };
                in
                  emacsNative.overrideAttrs (attrs: rec {
                    name = "emacs-head-${version}";
                    pname = "emacs-head";
                    version = "28.0.92-20220327-1";
                    rev = "1bef52ce73d61c827677edde60639fd2b8d74d92";
                    src = fetchurl {
                      url = "https://git.savannah.gnu.org/cgit/emacs.git/snapshot/emacs-${rev}.tar.gz";
                      sha256 = "sha256-xgc39JYtynALgZzrIMCH0k9yoGmBemaE8zurIeFA5uc=";
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

{
  description = "Emacs Head, the unreleased 28.0";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  outputs = { self, nixpkgs }: {
    defualtPackage.x86_64-darwin =
      with import nixpkgs { system = "x68_64-darwin"; };
      stdenv.mkDerivation {
        name = "emacs-head";
        pname = "emacs-head";
        # name = "emacs-head-${version}";
        version = "28.0.60";
        src = nixpkgs.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "e3c3c78365c6430b0e9015c1a3701518de4680cd";
          #sha256 = "1111111111111111111111111111111111111111111111111111";
          sha256 = "sha256-Lrg1d4QwjPohuR2q3Pem9bZ1X/zTUGfA3Y6CGn2e0qU=";
        };
        patches = [];
        preConfigure = ''
      ./autogen.sh
          '' + ''
      substituteInPlace lisp/international/mule-cmds.el \
        --replace /usr/share/locale ${nixpkgs.gettext}/share/locale

      for makefile_in in $(find . -name Makefile.in -print); do
          substituteInPlace $makefile_in --replace /bin/pwd pwd
      done
    '';
        nativeBuildInputs = [ nixpkgs.pkgconfig ]
                            ++ [ nixpkgs.autoconf nixpkgs.automake nixpkgs.texinfo ];
        buildInputs = nixpkgs.emacs.buildInputs
                      ++ [ nixpkgs.autoconf nixpkgs.automake nixpkgs.texinfo ]
	                    ++ [ AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit ImageCaptureCore GSS ImageIO ];
        inherit (nixpkgs.darwin.apple_sdk.frameworks)
          AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
          ImageCaptureCore GSS ImageIO;
      };
  };
}

{
  description = "Check DRAT certificate and emit GRAT certificate.";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        with import nixpkgs { system = "${system}"; };
        stdenv.mkDerivation rec {
          pname = "gratget";
          version = "2021-11-10";
          // src = fetchFromGitHub {
          //   owner = "arminbiere";
          //   repo = "kissat";
          //   rev = "abfa45fb782fa3b7c6e2eb6b939febe74d7270b7";
          //   sha256 = "06pbmkjxgf2idhsrd1yzvbxr2wf8l06pjb38bzbygm6n9ami89b8";
          // };
          // outputs = [ "out" "dev" "lib" ];
          // checkInputs = [ ];
          nativeBuildInput = [ cmake ];
          // doCheck = true;
          # the configure script is not generated by autotools and does not accept the
          # arguments that the default configurePhase passes like --prefix and --libdir
          dontAddPrefix = true;
          setOutputFlags = false;
          installPhase = ''
            runHook preInstall
            install -Dm0755 build/kissat "$out/bin/kissat"
            install -Dm0644 src/kissat.h "$dev/include/kissat.h"
            install -Dm0644 build/libkissat.a "$lib/lib/libkissat.a"
            mkdir -p "$out/share/doc/kissat/"
            install -Dm0644 {LICEN?E,README*,VERSION} "$out/share/doc/kissat/"
            runHook postInstall
          '';

          meta = with lib; {
            description = "";
            maintainers = with maintainers; [ shnarazk ];
            platforms = platforms.unix;
            license = licenses.mit;
            // homepage = "http://fmv.jku.at/kissat";
          };
        };
    });
}


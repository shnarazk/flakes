{
  description = "Check DRAT certificate and emit GRAT certificate.";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        with import nixpkgs { system = "${system}"; };
        stdenv.mkDerivation {
          pname = "gratget";
          version = "2021-11-10";
          src = fetchTarball {
            url = "https://www21.in.tum.de/~lammich/grat/gratgen.tgz";
            sha256 = "sha256:1qwnnlldm5phmhs8ay7g42qnsfp2wk4rkkhrxvwk7hq2r8ma88y9";
          };
          # outputs = [ "out" "dev" "lib" ];
          # checkInputs = [ ];
          nativeBuildInputs = [ pkg-config cmake ];
          buildInputs = [ boost ];
          # doCheck = true;
          # the configure script is not generated by autotools and does not accept the
          # arguments that the default configurePhase passes like --prefix and --libdir
          dontAddPrefix = true;
          setOutputFlags = false;
          installPhase = ''
            runHook preInstall
            install -Dm0755 gratgen "$out/bin/gratgen"
            runHook postInstall
          '';

          meta = with lib; {
            description = "A generator in Efficient Formally Verified SAT Solver Certification Toolchain";
            maintainers = with maintainers; [ shnarazk ];
            platforms = platforms.unix;
            license = licenses.mit;
            homepage = "https://www21.in.tum.de/~lammich/grat/";
          };
        };
    });
}


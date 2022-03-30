{
  description = "Check DRAT certificate and emit GRAT certificate.";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages =builtins.listToAttrs
    (map
      (system:
        with import nixpkgs { system = "${system}"; };
        {
          name = system;
          value = {
            default = 
              stdenv.mkDerivation {
                pname = "gratchk";
                version = "2021-11-10";
                src = fetchTarball {
                  url = "https://www21.in.tum.de/~lammich/grat/gratchk-sml.tgz";
                  sha256 = "sha256:1fg1li9pb3n4gc9429j9sjwb8bvfrxwidyjw85xchg2gg5iwam2k";
                };
                # outputs = [ "out" "dev" "lib" ];
                # checkInputs = [ ];
                nativeBuildInputs = [ mlton ];
                # buildInputs = [ ];
                # doCheck = true;
                # the configure script is not generated by autotools and does not accept the
                # arguments that the default configurePhase passes like --prefix and --libdir
                dontAddPrefix = true;
                setOutputFlags = false;
                installPhase = ''
                  runHook preInstall
                  install -Dm0755 gratchk "$out/bin/gratchk"
                  runHook postInstall
                '';

                meta = with lib; {
                  description = "A generator in Efficient Formally Verified SAT Solver Certification Toolchain";
                  maintainers = with maintainers; [ shnarazk ];
                  platforms = platforms.unix;
                  license = licenses.mit;
                  homepage = "https://www21.in.tum.de/~lammich/grat/";
                };
              }
            ;
          };
        }
      )
      [ "x86_64-linux" "x86_64-darwin" ]
    );
  };
}

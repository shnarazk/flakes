{
  description = "CaDiCaL flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
  {
    packages = builtins.listToAttrs (
      map
        (
          system: with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = stdenv.mkDerivation rec {
                pname = "cadical";
                version = "2.1.3";
                src = fetchFromGitHub {
                 owner = "arminbiere";
                  repo = "cadical";
                  rev = "rel-${version}";
                  sha256 = "W3kO+6nVzkmJXyHJU+NZWP0oatK3gon4EWF1/03rgL4=";
                };
                dontAddPrefix = true;
                installPhase = ''
                  install -Dm0755 build/cadical "$out/bin/cadical"
                  install -Dm0755 build/mobical "$out/bin/mobical"
                  mkdir -p "$out/share/doc/${pname}-${version}/"
                  install -Dm0755 {LICEN?E,README*,VERSION} "$out/share/doc/${pname}-${version}/"
                '';

                meta = with lib; {
                  description = "Simplified Satisfiability Solver";
                  maintainers = with maintainers; [ shnarazk ];
                  platforms = platforms.unix;
                  license = licenses.mit;
                  homepage = "http://fmv.jku.at/cadical";
                };
              };
            };
          }
        )
        [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ]
    );
  };
}

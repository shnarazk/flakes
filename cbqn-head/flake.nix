{
  description = "A BQN implementation in C";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.listToAttrs (
        map
          (
            system: with import nixpkgs { system = "${system}"; }; {
              name = system;
              value =
                let
                  builder =
                    { flags }:
                    let
                      bytecode-submodule = fetchFromGitHub {
                        name = "bytecode-submodule";
                        owner = "dzaima";
                        repo = "cbqnBytecode";
                        rev = "d8b2525cd11e30eef04a19f0cf1bc784c0d9ba10";
                        hash = "sha256-J4Ddz2EDykbSuDWmjRyEMeGUhdY4HG5pk+7LnAhEHJ8=";
                      };
                      replxx-submodule = fetchFromGitHub {
                        name = "replxx-submodule";
                        owner = "dzaima";
                        repo = "replxx";
                        rev = "bc3e0aaeabf299c43e19b13d23d6809967469872";
                        hash = "sha256-TRiGnHhRpM+0y/XSwqu2YP459tot5DSAN5Qqml1FNdE=";
                      };
                      singeli-submodule = fetchFromGitHub {
                        name = "singeli-submodule";
                        owner = "mlochbaum";
                        repo = "Singeli";
                        rev = "49a6a90d83992171a2db749e9f7fd400ec65ef2c";
                        hash = "sha256-9Dc6yrrXV6P9s1uwGlXB+ZBquOLejWe41k0TSpJGDgE=";
                      };
                    in
                    stdenv.mkDerivation rec {
                      pname = "cbqn-head";
                      version = "devel-20230917";
                      name = "${pname}-${version}-build.0";
                      src = fetchFromGitHub {
                        owner = "dzaima";
                        repo = "CBQN";
                        # rev = "refs/tags/v${version}";
                        rev = "6a0805eb9d1da306b4e51bda436e0c59cdf8f507";
                        sha256 = "sha256-lCS7k7vESDfSDtWEgIqMlAsJi9/TTmfSIPH22yeTAx8=";
                      };
                      nativeBuildInputs = [
                        pkg-config
                        libffi
                      ];
                      buildInputs = [
                        git
                        libffi
                      ];
                      dontConfigure = true;
                      # postPatch = ''
                      #   sed -i '/SHELL =.*/ d' makefile
                      # '';
                      makeFlags = flags;
                      # outputs = ["out" "lib" "dev"];
                      preBuild = ''
                        # Purity: avoids git downloading bytecode files by fullfilling *Local dirs
                        cp -r ${bytecode-submodule} build/bytecodeSubmodule
                        cp -r ${bytecode-submodule} build/bytecodeLocal
                        ls -l build/bytecodeLocal
                        cp -r ${replxx-submodule} build/replxxSubmodule
                        cp -r ${replxx-submodule} build/replxxLocal
                        # ls -l build/replxxLocal
                        cp -r ${singeli-submodule} build/singeliSubmodule
                        cp -r ${singeli-submodule} build/singeliLocal
                        # ls -l build/singeliLocal
                        # git init .
                        # git add README.md
                        # git commit -m "init"
                        echo "make for-build"
                        make for-build
                        # echo "make o3"
                        # make o3
                        echo "done"
                      '';
                      installPhase = ''
                        runHook preInstall
                        mkdir -p $out/bin/
                        cp BQN -t $out/bin/
                        # note guard condition for case-insensitive filesystems
                        [ -e $out/bin/bqn ] || ln -s $out/bin/BQN $out/bin/bqn
                        [ -e $out/bin/cbqn ] || ln -s $out/bin/BQN $out/bin/cbqn
                        make shared-o3
                        install -Dm644 include/bqnffi.h -t "$out/include"
                        install -Dm755 libcbqn.* -t "$out/lib"
                        runHook postInstall
                      '';
                      meta = with lib; {
                        description = "A BQN implementation in C";
                        homepage = "https://github.com/dzaima/CBQN/";
                        license = licenses.gpl3Plus;
                        maintainers = with maintainers; [
                          AndersonTorres
                          sternenseemann
                          synthetica
                          shnarazk
                        ];
                        platforms = platforms.all;
                      };
                    };
                in
                {
                  cbqn-head-o3 = builder { flags = [ "o3" ]; };
                  cbqn-head-o3n = builder {
                    flags = [
                      "o3n"
                      "has=avx2"
                    ];
                  };
                  default = builder { flags = [ "o3" ]; };
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

{
  description = "A BQN implementation in C with replxx singeli features";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { system = "${system}"; };
          {
            name = system;
            value = let builder = { flags }:
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
                  rev = "1da4681a8814366ec51e7630b76558e53be0997d";
                  hash = "sha256-Zs7ItuK31n0VSxwOsPUdZZLr68PypitZqcydACrx90Q=";
                };
                singeli-submodule = fetchFromGitHub {
                  name = "singeli-submodule";
                  owner = "mlochbaum";
                  repo = "Singeli";
                  rev = "ac9e7b7517a8b84aeebecfa360f0694629f83ec0";
                  hash = "sha256-mQ+xfIXItlDsErx93XAPqTAMKl2DrBoF/jELlMGm1tk=";
                };
              in
              stdenv.mkDerivation rec {
                pname = "cbqn-head";
                version = "pre0.4-20230823";
                name = "${pname}-${version}-build.0";
                src = fetchFromGitHub {
                  owner = "dzaima";
                  repo = "CBQN";
                  # rev = "refs/tags/v${version}";
                  rev = "bc796eac32b2512dd4572cebff42c019d34fddd1";
                  sha256 = "sha256-jS60phZMrpGa+GVzZSGZwVVtW9RBp/oHRIYP/pXRU2I=";
                };
                nativeBuildInputs = [ pkg-config libffi ];
                buildInputs = [ git libffi ];
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
                  maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk ];
                  platforms = platforms.all;
                };
              };

              in
              {
                cbqn-head-o3 = builder { flags = ["o3"]; };
                cbqn-head-o3n = builder { flags = ["o3" "has=avx2"]; };
                default = builder { flags = ["o3" "has=avx2"]; };
              }
            ;
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

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
            value = let builder = { flag }: let
                bytecode-submodule = fetchFromGitHub {
                  name = "bytecode-submodule";
                  owner = "dzaima";
                  repo = "cbqnBytecode";
                  rev = "4b895c6b7ff1cd76fd1aa873181e117fda23c9db";
                  hash = "sha256-Q+xJsmcU8Br4LVjKQ5iYCdwZrZ/YZpWztx7j7YV7H8Q=";
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
                version = "develop-20230810";
                name = "${pname}-${version}-build.0";
                src = fetchFromGitHub {
                  owner = "dzaima";
                  repo = "CBQN";
                  # rev = "refs/tags/v${version}";
                  rev = "a175c481042fb3d7aa15217edd361b84cd7fca86";
                  sha256 = "sha256-LoxwNxuadbYJgIkr1+bZoErTc9WllN2siAsKnxoom3Y=";
                };
                nativeBuildInputs = [ git pkg-config ];
                buildInputs = [ git libffi ];
                dontConfigure = true;
                postPatch = ''
                  sed -i '/SHELL =.*/ d' makefile
                '';
                # makeFlags = [flag "FFI=0"];
                # outputs = ["out" "lib" "dev"];
                preBuild = ''
                  # Purity: avoids git downloading bytecode files by fullfilling *Local dirs
                  cp -r ${bytecode-submodule} build/bytecodeLocal
                  ls -l build/bytecodeLocal
                  cp -r ${replxx-submodule} build/replxxLocal
                  ls -l build/replxxLocal
                  cp -r ${singeli-submodule} build/singeliLocal
                  ls -l build/singeliLocal
                  git init .
                  git add README.md
                  git commit -m "initialize"
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
                cbqn-head-o3 = builder { flag = "o3"; };
                cbqn-head-o3n = builder { flag = "o3n"; };
                default = builder { flag = "o3n"; };
              }
            ;
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

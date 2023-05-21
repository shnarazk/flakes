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
            value = let builder = { flag }:
                let
                  bytecode-submodule = fetchFromGitHub {
                    name = "bytecode-submodule";
                    owner = "dzaima";
                    repo = "cbqnBytecode";
                    rev = "32db4dfbfc753835bf112f3d8ae2991d8aebbe3d";
                    hash = "sha256-9uBPrEESn/rB9u0xXwKaQ7ABveQWPc8LRMPlnI/79kg=";
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
                    rev = "853ab1a06ae8d8603f228d8e784fa319cc401459";
                    hash = "sha256-X/NnufvakihJAE9H7geuuDS7Tv9l7tgLKdRgXC4ZX4A=";
                  };
                in
                stdenv.mkDerivation rec {
                  pname = "cbqn-head";
                  version = "0.3.0";
                  name = "${pname}-${version}-dev.2";
                  src = fetchFromGitHub {
                    owner = "dzaima";
                    repo = "CBQN";
                    rev = "refs/tags/v${version}";
                    sha256 = "sha256-LoxwNxuadbYJgIkr1+bZoErTc9WllN2siAsKnxoom3Y=";
                  };
                  nativeBuildInputs = [ pkg-config ];
                  buildInputs = [ libffi ];
                  dontConfigure = true;
                  postPatch = ''
                    sed -i '/SHELL =.*/ d' makefile
                  '';
                  makeFlags = [flag "FFI=0"];
                  # outputs = ["out" "lib" "dev"];
                  preBuild = ''
                    # Purity: avoids git downloading bytecode files by fullfilling *Local dirs
                    mkdir -p build/bytecodeLocal/gen
                    cp ${bytecode-submodule}/gen/* build/bytecodeLocal/gen/
                    mkdir -p build/replxxLocal
                    cp -r ${replxx-submodule}/* build/replxxLocal/
                    ls -l build/replxxLocal
                    mkdir -p build/singeliLocal
                    cp -r ${singeli-submodule}/* build/singeliLocal/
                    ls -l build/singeliLocal
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
                default = builder { flag = "o3"; };
              }
            ;
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

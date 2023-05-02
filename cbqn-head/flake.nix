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
            value = {
              default =
                let
                  bytecode-submodule = fetchFromGitHub {
                    name = "bytecode-submodule";
                    owner = "dzaima";
                    repo = "cbqnBytecode";
                    rev = "78ed4102f914eb5fa490d76d4dcd4f8be6e53417";
                    hash = "sha256-IOhxcfGmpARiTdFMSpc+Rh8VXtasZdfP6vKJzULNxAg=";
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
                    rev = "3327956fedfdc6aef12954bc12120f20de2226d0";
                    hash = "sha256-k25hk5zTn0m+2Nh9buTJYhtM98/VRlQ0guoRw9el3VE=";
                  };
                in
                stdenv.mkDerivation rec {
                  pname = "cbqn-head";
                  version = "0.2.0";
                  name = "${pname}-${version}-dev.3";
                  src = fetchFromGitHub {
                    owner = "dzaima";
                    repo = "CBQN";
                    rev = "refs/tags/v${version}";
                    sha256 = "sha256-M9GTsm65DySLcMk9QDEhImHnUvWtYGPwiG657wHg3KA=";
                  };
                  nativeBuildInputs = [ pkg-config ];
                  buildInputs = [ libffi ];
                  dontConfigure = true;
                  postPatch = ''
                    sed -i '/SHELL =.*/ d' makefile
                  '';
                  makeFlags = [
                    (if stdenv.hostPlatform.avx2Support then "o3n-singeli" else "o3-singeli")
                    "REPLXX=1"
                  ];
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
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}
 
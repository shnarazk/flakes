{
  description = "BQN implementation in C with replxx feature";
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
                  cbqn-bytecode-files = fetchFromGitHub {
                    name = "cbqn-bytecode-files";
                    owner = "dzaima";
                    repo = "CBQN";
                    rev = "3df8ae563a626ff7ae0683643092f0c3bc2481e5";
                    hash = "sha256:0rh9qp1bdm9aa77l0kn9n4jdy08gl6l7898lncskxiq9id6xvyb8";
                  };
                  replxx-submodule = fetchFromGitHub {
                    name = "replxx-submodule";
                    owner = "dzaima";
                    repo = "replxx";
                    rev = "d254e695e4a751fefa09eef52b1452b1835d05";
                    hash = "sha256-FrHAHSamAV4dBwu6iKJ0o4bnVYdR+2NHRQsB20zULq4=";
                  };
                in 
                stdenv.mkDerivation rec {
                  pname = "cbqn";
                  version = "0.pre+date=2022-11-27"; 
                  src = fetchFromGitHub {
                    owner = "dzaima";
                    repo = "CBQN";
                    rev = "dbc7c83f7085d05e87721bedf1ee38931f671a8e";
                    hash = "sha256:0nal1fs9y7nyx4d5q1qw868lxk7mivzw2y16wc3hw97pq4qf0dpb";
                  }; 
                  nativeBuildInputs = [ pkg-config ]; 
                  buildInputs = [ libffi ]; 
                  dontConfigure = true; 
                  postPatch = ''
                    sed -i '/SHELL =.*/ d' makefile
                  ''; 
                  makeFlags = [
                    "CC=${stdenv.cc.targetPrefix}cc"
                    "REPLXX=1"
                  ]; 
                  preBuild = ''
                    # Purity: avoids git downloading bytecode files
                    mkdir -p build/bytecodeLocal/gen
                    cp ${cbqn-bytecode-files}/src/gen/{compiles,explain,formatter,runtime0,runtime1,src} build/bytecodeLocal/gen/
                    cp -r ${replxx-submodule} build/replxxLocal/
                  ''
                  # Need to adjust ld flags for darwin manually
                  # https://github.com/dzaima/CBQN/issues/26
                  + lib.optionalString stdenv.hostPlatform.isDarwin '' makeFlagsArray+=(LD_LIBS="-ldl -lffi") ''; 
                  installPhase = ''
                     runHook preInstall 
                     mkdir -p $out/bin/
                     cp BQN -t $out/bin/
                     # note guard condition for case-insensitive filesystems
                     [ -e $out/bin/bqn ] || ln -s $out/bin/BQN $out/bin/bqn
                     [ -e $out/bin/cbqn ] || ln -s $out/bin/BQN $out/bin/cbqn 
                     runHook postInstall
                  '';  
                  meta = with lib; {
                    description = "BQN implementation in C";
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
 
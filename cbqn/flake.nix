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
                    repo = "cbqnBytecode";
                    rev = "8d2a4a27c94535ecfa59270270b817f1980de3ad";
                    hash = "sha256-7WiOthsQ314rXP+cjw9JRbPur00qkc8LVqUmKqdxn2U";
                  };
                  replxx-submodule = fetchFromGitHub {
                    name = "replxx-submodule";
                    owner = "dzaima";
                    repo = "replxx";
                    rev = "ba94c293caad52486df8712e808783df9a8f4501";
                    hash = "sha256-pMLvURksj/5k5b6BTwWxjomoROMOE5+GRjyaoqu/iYE";
                  };
                in 
                stdenv.mkDerivation rec {
                  pname = "cbqn";
                  version = "0.pre+date=2022-12-11"; 
                  src = fetchFromGitHub {
                    owner = "dzaima";
                    repo = "CBQN";
                    rev = "982a54d98a4d2a37f40d0cc711b0ad5e396613e3";
                    hash = "sha256-12R1KcPq88Bu9eI5QrHMfl2VEqqLCcS//DcJlxo4esM";
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
                    cp ${cbqn-bytecode-files}/gen/{compiles,explain,formatter,runtime0,runtime1,src} build/bytecodeLocal/gen/
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
 
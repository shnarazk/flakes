{
  description = "Alacritty overlay to Head, the 0.14.0";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.listToAttrs (
        map
          (
            system: with import nixpkgs { inherit system; }; {
              name = system;
              value = {
                default = alacritty.overrideAttrs (attrs: rec {
                  pname = "alacritty-head";
                  version = "0.14.0-rc2";
                  name = "${pname}-${version}";
                  src = fetchFromGitHub {
                    owner = "alacritty";
                    repo = "alacritty";
                    rev = "refs/tags/v${version}";
                    sha256 = "sha256-IzHkWA+5tbSKrAJ2XLFx09/uP5dzNNqdL7Qge8PlzJQ=";
                  };
                  # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                  nativeBuildInputs = alacritty.nativeBuildInputs ++ [ scdoc ];
                  cargoDeps = alacritty.cargoDeps.overrideAttrs (
                    lib.const {
                      name = "${pname}-vendor.tar.gz";
                      inherit src;
                      outputHash = "sha256-11n8FS+nCKP4JDv2RchttWKa5o6yKRyblDmRprGl83A=";
                    }
                  );
                  postInstall =
                    (
                      if stdenv.isDarwin then
                        ''
                          mkdir $out/Applications
                          cp -r extra/osx/Alacritty.app $out/Applications
                          ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
                        ''
                      else
                        ''
                          install -D extra/linux/Alacritty.desktop -t $out/share/applications/
                          install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
                          install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg

                          # patchelf generates an ELF that binutils' "strip" doesn't like:
                          #    strip: not enough room for program headers, try linking with -N
                          # As a workaround, strip manually before running patchelf.
                          $STRIP -S $out/bin/alacritty

                          patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
                        ''
                    )
                    + ''

                      installShellCompletion --zsh extra/completions/_alacritty
                      installShellCompletion --bash extra/completions/alacritty.bash
                      installShellCompletion --fish extra/completions/alacritty.fish

                      install -dm 755 "$out/share/man/man1"
                      install -dm 755 "$out/share/man/man5"
                      scdoc < extra/man/alacritty.1.scd | gzip -c > "$out/share/man/man1/alacritty.1.gz"
                      scdoc < extra/man/alacritty-msg.1.scd | gzip -c > "$out/share/man/man1/alacritty-msg.1.gz"
                      scdoc < extra/man/alacritty.5.scd | gzip -c > "$out/share/man/man5/alacritty.5.gz"
                      scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > "$out/share/man/man5/alacritty-bindings.5.gz"

                      # install -Dm 644 alacritty.yml $out/share/doc/alacritty.yml

                      install -dm 755 "$terminfo/share/terminfo/a/"
                      tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
                      mkdir -p $out/nix-support
                      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
                    '';
                });
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

{
  description = "Alacritty overlay to Head, the released 0.13.0";
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  outputs = { self, nixpkgs }: {
    packages = builtins.listToAttrs
      (map
        (system:
          with import nixpkgs { inherit system; }; {
            name = system;
            value = {
              default = alacritty.overrideAttrs (attrs: rec {
                pname = "alacritty-head";
                version = "0.13.0-rc1";
                name = "${pname}-${version}";
                src = fetchFromGitHub {
                  owner = "alacritty";
                  repo = "alacritty";
                  rev = "refs/tags/v${version}";
                  sha256 = "sha256-5PK8poco+HXbd6zuSjr9of2qSgC8puSTSzZnI4vvXEI=";
                };
                # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
                cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
                  name = "${pname}-vendor.tar.gz";
                  inherit src;
                  outputHash = "sha256-EaJaSGqc1vQURdkZLs2h/6You33wDmHNgg+BaHlvVs8=";
                });
                outputs = [ "out" ];
                postInstall = (
                    if stdenv.isDarwin then ''
                      mkdir $out/Applications
                      cp -r extra/osx/Alacritty.app $out/Applications
                      ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
                    '' else ''
                      install -D extra/linux/Alacritty.desktop -t $out/share/applications/
                      install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
                      install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg

                      # patchelf generates an ELF that binutils' "strip" doesn't like:
                      #    strip: not enough room for program headers, try linking with -N
                      # As a workaround, strip manually before running patchelf.
                      $STRIP -S $out/bin/alacritty

                      patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
                    ''
                  ) + ''

                    installShellCompletion --zsh extra/completions/_alacritty
                    installShellCompletion --bash extra/completions/alacritty.bash
                    installShellCompletion --fish extra/completions/alacritty.fish

                    # install -dm 755 "$out/share/man/man1"
                    # gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"
                    # gzip -c extra/alacritty-msg.man > "$out/share/man/man1/alacritty-msg.1.gz"

                    # install -Dm 644 alacritty.yml $out/share/doc/alacritty.yml

                    # install -dm 755 "$terminfo/share/terminfo/a/"
                    # tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
                    # mkdir -p $out/nix-support
                    # echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
                  '';

              });
            };
          }
        )
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
      )
    ;
  };
}

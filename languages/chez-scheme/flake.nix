{
  description = "A flake for building binaries in chez-scheme";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    chez-exe.url = "github:rschardt/chez-exe";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
    } @ inputs:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        chez = pkgs.chez-racket;
        chez-exe = inputs.chez-exe.packages.${system}.default;
      in
        rec {
          packages = rec {

            default = binary_onlyRunnableOnNixOS;

            # a chez-scheme binary compiled this way relies
            # on a scheme-interpreter installed locally
            # note: this binary will only run on nixos
            binary_onlyRunnableOnNixOS = pkgs.stdenv.mkDerivation {
              name = "hello-world";
              version = "0.0.1";
              src = ./src/.;
              buildInputs = [
                chez
              ];

              installPhase = ''
                mkdir -p $out/bin

                scheme -q << END
                  (reset-handler abort)
                  (optimize-level 2)
                  (compile-imported-libraries #t)
                  (generate-wpo-files #t)
                  (compile-program "hello-world.ss" "hello-world.so")
                  (compile-whole-program "hello-world.wpo" "hello-world")
                END

                chmod +x hello-world
                mv hello-world $out/bin/hello-world
              '';
            };

            # for a truely self contained binary using
            # chez-exe(https://github.com/gwatt/chez-exe/tree/master) is advised
            # note: this binary will only run on nixos
            binary_standAloneNixos = pkgs.stdenv.mkDerivation {
              name = "hello-standalone-nixos";
              version = "0.0.1";
              src = ./src/.;
              buildInputs = [
                chez
                chez-exe
                pkgs.libuuid
              ];

              buildPhase = ''
                compile-chez-program --optimize-level 2 hello-world.ss
              '';

              installPhase = ''
                mkdir -p $out/bin
                chmod +x hello-world
                mv hello-world $out/bin/hello-world
              '';
            };

            # this binary will run on other linuxes(not nixos)
            # but only for the x86-64 architecture atm
            # tested on Archlinux and Ubuntu docker images
            # note: this binary will not run on nixos but others
            binary_otherLinuxes = pkgs.stdenv.mkDerivation {
              name = "abcirdc-binary-otherLinux";
              version = "0.0.1";
              src = packages.binary_standAloneNixos;

              installPhase = ''
                mkdir -p $out/bin
                cp bin/hello-world $out/bin
                patchelf --set-rpath /lib64/ld-linux-x86-64.so.2 $out/bin/hello-world
                patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/bin/hello-world
              '';

              dontFixup = true;
            };
          };

          apps.default = { type = "app"; program = "${packages.default}/bin/hello-world"; };
        }
    );
}

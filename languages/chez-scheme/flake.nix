{
  description = "A flake for building binaries in chez-scheme";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        chez = pkgs.chez-racket;
      in
        rec {
          packages = rec {
            default = binary_onlyRunnableOnNixOS;
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
          };

          apps.default = { type = "app"; program = "${packages.default}/bin/hello-world"; };
        }
    );
}

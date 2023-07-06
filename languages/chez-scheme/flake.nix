{
  description = "A flake for building binaries in chez-scheme";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nix-bundle.url = "github:matthewbauer/nix-bundle";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    nix-bundle,
    ...
  }:
    #utils.lib.eachDefaultSystem (
    utils.lib.eachSystem ["x86_64-linux"] (
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

            # 0. not working with 'nix bundle'
            # 1.(nix-bundle mathewbauer) not working for aarch64-darwin
            # 1a. only working for [ "x86_64-linux" "i686-linux" "aarch64-linux" ] from https://github.com/matthewbauer/nix-bundle/blob/master/flake.nix
            # 2. doesn't work with flake pkgs, maybe works with pkgs from nixpkgs
            # try overriding nixpkgs:  https://nixos.org/guides/nix-pills/nixpkgs-overriding-packages.html#idm140737319619744
            # 3A. try to create a self contained binary with chez-exe
            # 3B. try to modify 'env scheme' at the top of the file and package scheme-interpreter with binary
            # 4. try to create a platform specific image with boot file
            binary_withNixBundle = let
              nixpkgs = nixpkgs.legacyPackages.${system}.override {
                binary_onlyRunnableOnNixos = packages.binary_onlyRunnableOnNixOS;
              };
            in
              nix-bundle.bundlers.nix-bundle { program=nixpkgs.binary_onlyRunnableOnNixos; system=system; };
            #binary_withNixBundle = nix-bundle.bundlers.nix-bundle { program=packages.default; system=system; };
          };

          apps.default = { type = "app"; program = "${packages.default}/bin/hello-world"; };
        }
    );
}

{
  description = "Example flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    # Note that 'nix shell' only works
    # when defaultPackage or another output is a pkgs.buildEnv or mkShell
    defaultPackage.x86_64-linux = pkgs.stdenv.mkDerivation {

      name = "exampleApp";
      src = ./.;
      buildInputs = with pkgs; [
        lolcat
      ];
      installPhase = ''
        mkdir -p $out
        echo "hello world" | tee example.txt
        mv example.txt $out
      '';
    };
  };
}

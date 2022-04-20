{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
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
}

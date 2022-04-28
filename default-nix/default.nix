{ pkgs ? import <nixpkgs> {} }:

with pkgs; derivation {
  name = "exampleRustApp";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  buildInputs = [ coreutils gcc rustc ]; # required by builder.sh
  src = ./.;
  system = builtins.currentSystem;
}

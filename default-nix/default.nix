{ pkgs ? import <nixpkgs> {} }:

with pkgs; derivation {
  name = "exampleApp";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  buildInputs = [ coreutils ];
  system = builtins.currentSystem;
}

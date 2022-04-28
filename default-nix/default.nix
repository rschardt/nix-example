{ pkgs ? import <nixpkgs> {} }:

with pkgs; derivation {
  name = "exampleRustApp";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  buildInputs = [
    coreutils
    gcc
    rustc
    findutils
    patchelf
  ]; # required by builder.sh
  src = ./.; # is optional
  system = builtins.currentSystem;
}

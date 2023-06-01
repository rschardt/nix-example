{
    system ? builtins.currentSystem,
    pkgs ? import <nixpkgs> { inherit system; }
}:

derivation { # This is the entry point to the nix package manager
  ### required:

  name = "exampleRustApp";

  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ]; # optional, defaults to []

  inherit system;

  ### additional (not expected by nix):

  mySrc = ./src;

  # required by builder.sh
  myDependencies = with pkgs; [
    coreutils
    gcc
    rustc
    findutils
    patchelf
  ];

  ### additional, but required to use nix-shell:

  # nix-shell calls $stdenv/setup
  # ./setup sets up $PATH
  stdenv = ./.;
}

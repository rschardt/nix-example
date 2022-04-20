{
  description = "Example flake";

  inputs = {
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, devshell }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    defaultPackage.x86_64-linux = import ../default-nix/default.nix { inherit pkgs; };
    devShell = pkgs.devshell.fromTOML ./devshell.toml;
  };
}

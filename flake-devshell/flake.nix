{
  description = "Example flake";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend (nixpkgs.lib.composeManyExtensions [
          devshell.overlay
        ]);
      in
      {
        defaultPackage = import ../default-nix/default.nix { inherit pkgs; };
        devShell = pkgs.devshell.fromTOML ./devshell.toml;
      }
  );
}

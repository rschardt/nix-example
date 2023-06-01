{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  outputs = { nixpkgs, ... }: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      sha512 = import <nix/fetchurl.nix> {
        url = "https://sha512.tgz";
        hash = "sha512-?";
      };
      sha256 = import <nix/fetchurl.nix> {
        #impure = true;
        url = "https://sha256.tgz";
        sha256 = "?";
      };
    };
  };
}

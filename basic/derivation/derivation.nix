{ pkgs, ...}:
derivation {
  name = "derivationExample";

  builder = "${pkgs.bash}/bin/bash";
  args = [ ./builder.sh ];

  system = "x86_64-linux";

  mySrc = ./.;
  myDependency = pkgs.coreutils;
}



# Simple derivation for using with nix repl

Open repl:
```
nix repl '<nixpkgs>'
```

Build derivation from inside repl:
```
nix-repl> :b import ./derivation.nix { inherit pkgs; }
```


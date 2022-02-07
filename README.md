# Cardano shim: Nix adapter

This is just a flake

## Goals
- workaround [FUP] channel detection magic, which triggers on some of IOHK's flakes
- disable `import-from-derivation` using [the prescribed method](manually-generating-nix-expressions)

[FUP]: https://github.com/gytis-ivaskevicius/flake-utils-plus
[manually-generating-nix-expressions]: https://input-output-hk.github.io/haskell.nix/dev/manually-generating-nix-expressions.html

# Cardano shim: Nix adapter

When Daedalus gets flakified I will most likely switch to that.

## Goals
- workaround [FUP] channel detection magic, which triggers on some of IOHK's flakes
- ~~disable `import-from-derivation`~~ make it manageable for me with the `ifd-pin` tool.

[FUP]: https://github.com/gytis-ivaskevicius/flake-utils-plus

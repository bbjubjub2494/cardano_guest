{ mkShell, haskellPackages, haskell-nix }:

mkShell {
        buildInputs = [
          haskell-nix.nix-tools.ghc8107
          haskellPackages.cabal-install
          haskellPackages.ghc
        ];
      }

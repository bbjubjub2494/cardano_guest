{ mkShell, haskellPackages, haskell-nix, compiler-nix-name ? "ghc8107" }:

mkShell {
        buildInputs = [
          haskell-nix.nix-tools.${compiler-nix-name}
          haskellPackages.cabal-install
          haskellPackages.ghc
        ];
      }

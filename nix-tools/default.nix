{ compiler-nix-name ? "ghc8107"
}:
let
  sources = import ./nix/sources.nix {};
  haskellNix = import sources."haskell.nix" {};
  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;
  plan-pkgs = import ./plan-pkgs.nix;
  pkg-set = pkgs.haskell-nix.mkCabalProjectPkgSet {
    inherit compiler-nix-name plan-pkgs;
  };
  args = {
    src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; name = "nix-tools"; };
    inherit compiler-nix-name;
    shell = {
      tools.cabal = {};
      buildInputs = [
        pkgs.nix-prefetch-git
      ];
    };
  };
  project = pkgs.haskell-nix.addProjectAndPackageAttrs {
    inherit (pkg-set.config) hsPkgs;
    inherit pkg-set args;
  };
in
project


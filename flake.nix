# The flake file is the entry point for nix commands
{
  description = "An adapter around iohk's nix projects";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nix-tools.url = "path:nix-tools/";
  inputs.nix-tools.flake = false;
  inputs.haskell-nix.url = "path:haskell-nix/";
  inputs.haskell-nix.inputs.nix-tools.follows = "nix-tools";
  inputs.cardano-node.url = "path:cardano-node/";
  inputs.cardano-node.inputs.haskellNix.follows = "haskell-nix";
  inputs.cardano-node.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.cardano-wallet.url = "path:cardano-wallet/";
  inputs.cardano-wallet.inputs.haskellNix.follows = "haskell-nix";
  inputs.cardano-wallet.inputs.nixpkgs.follows = "nixpkgs";

  inputs.config.url = "github:lourkeur/config";
  inputs.config.inputs.cardano.follows = "/";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, haskell-nix, cardano-node, cardano-wallet, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    sharedOverlays = [
      inputs.config.overlays.nix  # fix https://github.com/NixOS/nix/issues/6013
      (final: _: {
        inherit (haskell-nix.legacyPackages.${final.system}) haskell-nix;
        inherit (cardano-node.legacyPackages.${final.system}) cardano-node;
        inherit (cardano-wallet.packages.${final.system}) cardano-wallet;
      })
    ];

    nixosModules = {
      inherit (inputs.cardano-node.nixosModules) cardano-node;
      inherit (inputs.cardano-wallet.nixosModules) cardano-wallet;
    };

    outputsBuilder = channels: {
      devShell = channels.nixpkgs.callPackage nix/devshell.nix { };
      devShells.withGHC8105 = channels.nixpkgs.callPackage nix/devshell.nix {
        compiler-nix-name = "ghc8105";
      };

      packages = {
        inherit (channels.nixpkgs) cardano-node;
        inherit (channels.nixpkgs) cardano-wallet;
      };

      checks.cardano-node-system = (nixpkgs.lib.nixosSystem {
        inherit (channels.nixpkgs) system;
        modules = [
          self.nixosModules.cardano-node
          {
            boot.isContainer = true;
            services.cardano-node.enable = true;
          }
        ];
      }).config.system.build.toplevel;

      checks.cardano-wallet-system = (nixpkgs.lib.nixosSystem {
        inherit (channels.nixpkgs) system;
        modules = [
          self.nixosModules.cardano-node
          self.nixosModules.cardano-wallet
          {
            boot.isContainer = true;
            services.cardano-wallet.enable = true;
          }
        ];
      }).config.system.build.toplevel;
    };
  };
}

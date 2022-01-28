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

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, haskell-nix, cardano-node, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    sharedOverlays = [
      (final: _: {
        inherit (haskell-nix.legacyPackages.${final.system}) haskell-nix;
        inherit (cardano-node.legacyPackages.${final.system}) cardano-node;
      })
    ];

    nixosModules = {
      inherit (inputs.cardano-node.nixosModules) cardano-node;
    };

    outputsBuilder = channels: {
      devShell = channels.nixpkgs.callPackage nix/devshell.nix { };

      packages = {
        inherit (channels.nixpkgs) cardano-node;
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
    };
  };
}

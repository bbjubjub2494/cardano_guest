# The flake file is the entry point for nix commands
{
  description = "An adapter around iohk's nix projects";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.cardano-node.url = "github:input-output-hk/cardano-node/1.33.0";
  inputs.cardano-node.inputs.nixpkgs.follows = "nixpkgs";

  inputs.cardano-wallet.url = "github:lourkeur/cardano-wallet/v2022-01-18";
  inputs.cardano-wallet.inputs.nixpkgs.follows = "nixpkgs";

  inputs.config.url = "github:lourkeur/config";
  inputs.config.inputs.cardano.follows = "/";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, cardano-node, cardano-wallet, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    sharedOverlays = [
      inputs.config.overlays.nix  # fix https://github.com/NixOS/nix/issues/6013
    ];

    nixosModules = {
      inherit (inputs.cardano-node.nixosModules) cardano-node;
      inherit (inputs.cardano-wallet.nixosModules) cardano-wallet;
    };

    outputsBuilder = channels: {
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

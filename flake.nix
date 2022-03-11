# The flake file is the entry point for nix commands
{
  description = "An adapter around iohk's nix projects";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nixpkgs.url = "nixpkgs/nixos-21.11";

  inputs.cardano-node.url = "github:input-output-hk/cardano-node/1.34.1";
  inputs.cardano-node.inputs.nixpkgs.follows = "nixpkgs";

  inputs.cardano-wallet.url = "github:lourkeur/cardano-wallet";
  inputs.cardano-wallet.inputs.nixpkgs.follows = "nixpkgs";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, cardano-node, cardano-wallet, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    nixosModules = {
      inherit (inputs.cardano-node.nixosModules) cardano-node;
      inherit (inputs.cardano-wallet.nixosModules) cardano-wallet;
    };

    outputsBuilder = channels: with channels.nixpkgs; {
      checks.cardano-node-system = (nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          self.nixosModules.cardano-node
          {
            boot.isContainer = true;
            services.cardano-node.enable = true;
          }
        ];
      }).config.system.build.toplevel;

      checks.cardano-wallet-system = (nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          self.nixosModules.cardano-node
          self.nixosModules.cardano-wallet
          {
            boot.isContainer = true;
            services.cardano-wallet.enable = true;
          }
        ];
      }).config.system.build.toplevel;

      packages = {
        inherit (cardano-node.packages.${system}) cardano-node;
        ifd-pin = writeShellApplication {
          name = "ifd-pin";
          text = builtins.readFile ./ifd-pin.sh;
        };
      };
    };
  };
}

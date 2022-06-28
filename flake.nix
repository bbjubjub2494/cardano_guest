# The flake file is the entry point for nix commands
{
  description = "An adapter around iohk's nix projects";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;

  inputs.cardano-node.url = "github:input-output-hk/cardano-node/1.35.0";

  inputs.cardano-wallet.url = "github:lourkeur/cardano-wallet";

  nixConfig.extra-substituters = "https://hydra.iohk.io";
  nixConfig.extra-trusted-public-keys = "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, cardano-node, cardano-wallet, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    supportedSystems = [ "x86_64-linux" ];

    nixosModules = {
      cardano-node = { pkgs, ... }: {
        imports = [inputs.cardano-node.nixosModules.cardano-node];
        services.cardano-node.package = cardano-node.packages.${pkgs.system}.cardano-node;
      };
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
        ifd-pin = writeShellApplication {
          name = "ifd-pin";
          text = builtins.readFile ./ifd-pin.sh;
        };
      };
    };
  };
}

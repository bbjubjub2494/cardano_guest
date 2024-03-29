# The flake file is the entry point for nix commands
{
  description = "A container running a Cardano full node and wallet";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;

  inputs.cardano-node.url = "github:input-output-hk/cardano-node/1.35.7";

  inputs.cardano-wallet.url = "github:input-output-hk/cardano-wallet/v2023-04-14";

  nixConfig.extra-substituters = "https://hydra.iohk.io";
  nixConfig.extra-trusted-public-keys = "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs @ {
    self,
    flake-parts,
    cardano-node,
    cardano-wallet,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {
      inherit inputs;
    } {
      systems = ["x86_64-linux"];

      flake.nixosConfigurations.cardano = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          cardano-node.nixosModules.cardano-node
          cardano-wallet.nixosModules.cardano-wallet
          ({
            config,
            modulesPath,
            pkgs,
            ...
          }: {
            imports = [
              "${modulesPath}/virtualisation/lxc-container.nix"
            ];

            networking.hostName = "cardano";

            nix.registry.config.to = {
              type = "github";
              owner = "lourkeur";
              repo = "cardano_guest";
            };

            services.cardano-node.enable = true;
            services.cardano-node.environment = "mainnet";
            services.cardano-node.package = cardano-node.packages.${pkgs.system}.cardano-node;
            systemd.services.cardano-wallet.serviceConfig = {
              RestartSec = "3s";
              Restart = "always";
            };

            services.cardano-wallet.enable = true;
            services.cardano-wallet.package =
              # default value: ((import ../.. { }).legacyPackages.${pkgs.system}).hsPkgs.cardano-wallet.components.exes.cardano-wallet
              # avoid self-import because it triggers impurities
              cardano-wallet.legacyPackages.${pkgs.system}.hsPkgs.cardano-wallet.components.exes.cardano-wallet;

            users.users.cardano = {
              isNormalUser = true;
              uid = 3001;
              packages = [config.services.cardano-wallet.package];
            };

            users.allowNoPasswordLogin = true; # I use lxc-attach so it's fine

            users.mutableUsers = false;
            boot.tmpOnTmpfs = true;

            system.stateVersion = "22.05";
          })
        ];
      };

      perSystem = {
        inputs',
        self',
        pkgs,
        ...
      }:
        with pkgs; {
          packages = {
            ifd-pin = writeShellApplication {
              name = "ifd-pin";
              text = builtins.readFile ./ifd-pin.sh;
            };
            inherit (inputs'.cardano-node.packages) cardano-node;
          };
          devShells.default = mkShell {
            buildInputs = [
              self'.packages.ifd-pin
              go-task
            ];
          };
          formatter = alejandra;
        };
    };
}

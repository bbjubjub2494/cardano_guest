# The flake file is the entry point for nix commands
{
  description = "An adapter around iohk's nix projects";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nix-tools.url = "path:nix-tools/";
  inputs.nix-tools.flake = false;
  inputs.haskell-nix.url = "github:input-output-hk/haskell.nix";
  inputs.haskell-nix.inputs.nix-tools.follows = "nix-tools";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs@{ self, fup, haskell-nix, nixpkgs, ... }: fup.lib.mkFlake {

    inherit self inputs;

    sharedOverlays = [
      (final: _: {
        inherit (haskell-nix.legacyPackages.${final.system}) haskell-nix;
      })
    ];

    outputsBuilder = channels: {
      devShell = channels.nixpkgs.callPackage nix/devshell.nix { };
    };
  };
}

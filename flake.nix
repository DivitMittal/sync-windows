{
  description = "Windows flake";

  outputs = inputs: let
    inherit (inputs.flake-parts.lib) mkFlake;
  in
    mkFlake {inherit inputs;} {
      systems = builtins.import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
        ./flake/nixpkgs.nix
        inputs.devshell.flakeModule
      ];

      perSystem = {pkgs, ...}: {
        devshells.default = {
          packages = builtins.attrValues {
            inherit
              (pkgs)
              powershell
              ;
          };
        };

        treefmt = {
          projectRootFile = "flake.nix";

          flakeCheck = false;

          programs = {
            #typos.enable = true;
            ## Nix
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    "nixpkgs-2605".url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # nix-systems/default dropped x86_64-darwin in c29398b5; pin the last
    # revision that still lists it so lock bumps keep x86_64-darwin outputs.
    systems.url = "github:nix-systems/default/da67096a3b9bf56a91d16901293e51ba5b49a27e";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

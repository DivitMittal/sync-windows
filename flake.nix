{
  description = "Windows flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs.flake-parts.lib) mkFlake;
  in
    mkFlake {inherit inputs;} {
      systems = builtins.import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
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
            ## JSON
            prettier.enable = true;
          };
        };
      };
    };
}

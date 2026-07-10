{
  description = "Neovim configuration flake - deployable across Nix systems";

  inputs = {
    nixpkgs.follows = "nixvim/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Build the configured Neovim from the module
        nvim = nixvim.lib.evalNixvim {
          inherit system;
          modules = [ ./nixvim.nix ];
        };
        nvimPackage = nvim.config.build.package;

      in
      {
        # This package installs Neovim with your configuration applied
        packages = {
          default = nvimPackage;
        };

        # For direct execution (nix run .)
        apps = {
          default = {
            type = "app";
            program = "${nvimPackage}/bin/nvim";
          };
        };

        # For use with home-manager
        homeModules = {
          default = { pkgs, ... }: {
            programs.nixvim = {
              enable = true;
            } // import ./nixvim.nix { pkgs = pkgs; };
          };
        };

        # For use with NixOS
        nixosModules = {
          default = { pkgs, ... }: {
            programs.nixvim = {
              enable = true;
            } // import ./nixvim.nix { pkgs = pkgs; };
          };
        };
      });
}
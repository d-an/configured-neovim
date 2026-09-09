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

        # Import nixpkgs for this system (needed for devShells)
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Package for installation: nix profile install .
        packages.default = nvimPackage;

        # App for direct execution: nix run .
        apps.default = {
          type = "app";
          program = "${nvimPackage}/bin/nvim";
        };

        # Development shell with nvim available
        devShells.default = pkgs.mkShell {
          packages = [ nvimPackage ];
        };
        # Export the nixvim module for use in NixOS or Home Manager configurations
        # Usage: imports = [ your-flake.nixosModules.default ];
        nixosModules.default = ./nixvim.nix;

        # Usage: imports = [ your-flake.homeModules.default ];
        homeModules.default = ./nixvim.nix;
      });
}


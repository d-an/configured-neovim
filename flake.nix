{
  description = "Neovim configuration flake - deployable across Nix systems";

  inputs = {
    nixpkgs.follows = "nixvim/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }:
    let
      # Create a proper NixOS module that wraps nixvim
      nixosModule = { pkgs, ... }: {
        imports = [
          nixvim.nixosModules.default  # Import upstream nixvim module
        ];
        
        # Enable nixvim
        programs.nixvim = {
          enable = true;
          imports = [ ./nixvim.nix ];
        };
      };
      
      # Create a proper Home Manager module
      homeModule = { pkgs, ... }: {
        imports = [
          nixvim.homeModules.default
        ];
        
        # Enable nixvim
        programs.nixvim = {
          enable = true;
          imports = [ ./nixvim.nix ];
        };
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        nvim = nixvim.lib.evalNixvim {
          inherit system;
          modules = [ ./nixvim.nix ];
        };
        nvimPackage = nvim.config.build.package;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = nvimPackage;
        apps.default = {
          type = "app";
          program = "${nvimPackage}/bin/nvim";
        };
        devShells.default = pkgs.mkShell {
          packages = [ nvimPackage ];
        };
      }) // {
        # Export the wrapped modules
        nixosModules.default = nixosModule;
        homeModules.default = homeModule;
      };
}


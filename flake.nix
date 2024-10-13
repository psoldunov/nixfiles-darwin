{
  description = "BigMac Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "aarch64-darwin";
  in {
    darwinConfigurations.BigMac = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit self inputs outputs;
      };
      modules = [
        ./darwin/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default
        {
          environment.systemPackages = [agenix.packages.${system}.default];
        }
        {
          home-manager = {
            extraSpecialArgs = {
              inherit inputs outputs;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            users = {
              psoldunov =
                import ./home-manager/home.nix;
            };
            sharedModules = [
              agenix.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}

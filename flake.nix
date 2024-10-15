{
  description = "BigMac Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
    nixpkgs-stable,
    darwin,
    sops-nix,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "aarch64-darwin";

    pkgs-stable = import nixpkgs-stable {
      inherit system;
    };
  in {
    darwinConfigurations.BigMac = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit self inputs outputs pkgs-stable;
      };
      modules = [
        ./darwin/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
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
              sops-nix.homeManagerModules.sops
            ];
          };
        }
      ];
    };
  };
}

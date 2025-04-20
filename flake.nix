{
  description = "System configuration as a flake, I guess?";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    kmonad,
    nixos-cosmic,
    # solaar,
    ...
  } @ inputs: {
    nixosConfigurations = let
      homeManagerSettings = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";

        home-manager.users.litoprobka = import ./litoprobka-home.nix;
        home-manager.users.marsle = import ./mars-home.nix;
      };
      nixSettings = {
        nix.settings = {
          substituters = ["https://cosmic.cachix.org/"];
          trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
        };
        nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
            (final: _prev: {
                stable = import nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
              };
            })
        ];
      };
    in {
      litopc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./litopc/configuration.nix
          home-manager.nixosModules.home-manager
          homeManagerSettings
          nixSettings
        ];
      };
      litolaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./litolaptop/configuration.nix
          home-manager.nixosModules.home-manager
          homeManagerSettings
          nixSettings
          kmonad.nixosModules.default
          nixos-cosmic.nixosModules.default
        ];
      };
      mars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./mars/configuration.nix
          home-manager.nixosModules.home-manager
          homeManagerSettings
          nixSettings
          kmonad.nixosModules.default
        ];
      };
    };
  };
}

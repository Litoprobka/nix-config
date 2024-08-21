{
  description = "System configuration as a flake, I guess?";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kmonad,
    nixos-cosmic,
    ...
  } @ inputs: {
    nixosConfigurations = let
      homeManagerSettings = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";

        home-manager.users.litoprobka = import ./home.nix;
      };
      nixSettings = {
        nix.settings = {
          substituters = ["https://cosmic.cachix.org/"];
          trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
        };
        nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
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
    };
  };
}

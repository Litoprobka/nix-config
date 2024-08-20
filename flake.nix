{
  description = "System configuration as a flake, I guess?";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kmonad,
    nixos-cosmic,
    ...
  } @ inputs: {
    nixosConfigurations = {
      litopc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./litopc/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.litoprobka = import ./home.nix;
          }
        ];
      };
      litolaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./litolaptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.litoprobka = import ./home.nix;
          }
          kmonad.nixosModules.default
          {
            nix.settings = {
              substituters = ["https://cosmic.cachix.org/"];
              trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
            };
          }
          nixos-cosmic.nixosModules.default
        ];
      };
    };
  };
}

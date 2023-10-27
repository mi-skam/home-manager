{
  description = "Home Manager configuration of plumps";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      mkHomeConfig = machineModule: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [ ./home.nix machineModule ];

          extraSpecialArgs = { inherit inputs system; };
        };
    in {
      homeConfigurations."plumps@linux" =
        mkHomeConfig ./linux/plumps.nix "x86_64-linux";
      homeConfigurations."plumps@macos" =
        mkHomeConfig ./macos/plumps.nix "aarch64-darwin";
    };
}


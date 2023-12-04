{
  description = "Home Manager configuration of plumps";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      mkHomeConfig = machineModule: system:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix machineModule ];

          extraSpecialArgs = { inherit inputs system; };
        };
    in {
      # this output is only needed for the `home-manager news` command.
      homeConfigurations."plumps" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
      homeConfigurations."plumps@linux" =
        mkHomeConfig ./linux/plumps.nix "x86_64-linux";
      homeConfigurations."plumps@linux-wsl" =
        mkHomeConfig ./linux-wsl/plumps.nix "x86_64-linux";
      homeConfigurations."plumps@macos" =
        mkHomeConfig ./macos/plumps.nix "aarch64-darwin";
    };
}


{
  description = "A NickOS flake";

  inputs = {
    # Nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Some serivces/programs defined here exist on NUR only.
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GPU Driver
    mesa-git = {
      url = "git+https://gitlab.freedesktop.org/mesa/mesa?ref=main";
      flake = false;
    };

    # Misc
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";
  };
  outputs = inputs@{ self, nixpkgs, nix-colors, catppuccin, home-manager, ... }:
    let
    	system = "x86_64-linux";
     	pkgs = nixpkgs.legacyPackages.${system};
      	inherit (self) outputs;
    in
    {

    # System configurations and modules
    nixosModules = import ./nixos/modules;

    # Home-manager configurations and modules
    homeModules = import ./home/modules;

    nixosConfigurations = {
      artorias = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs nix-colors; };
        modules = [
          # inputs.hyprland.nixosModules.default
          ./nixos/configurations/configuration.nix

          home-manager.nixosModules.home-manager
          {
          	home-manager =
           	{
            	extraSpecialArgs = {inherit inputs outputs nix-colors catppuccin; };
            	useGlobalPkgs = true;
             	useUserPackages = true;
              	users.nick = import ./home/configurations/configuration.nix;
            };
          }
        ];
      };
    };
  };
}

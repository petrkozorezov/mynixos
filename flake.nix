{
  description = "My NixOS configuration";

  inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager";
  };

  outputs = { home-manager, nixpkgs, ... }: {
    nixosConfigurations.petrkozorezov-notebook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.petrkozorezov = import ./home.nix;
          };
        }
      ];
    };
  };
}

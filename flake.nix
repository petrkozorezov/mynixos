{
  description = "My NixOS configuration";

  inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    petrkozorezov-notebook = self.nixosConfigurations.petrkozorezov-notebook.config.system.build.toplevel;

    nixosConfigurations = {
      petrkozorezov-notebook =
        nixpkgs.lib.nixosSystem {
          system  = "x86_64-linux";
          modules =
            [
              ./hardware
              ./configuration.nix
              home-manager.nixosModules.home-manager {
                home-manager = {
                  useGlobalPkgs       = true;
                  useUserPackages     = true;
                  users.petrkozorezov = import ./home.nix;
                };
              }
            ];
        };
    };
  };
}

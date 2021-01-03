{
  description = "My NixOS configuration";

  inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    petrkozorezov-x1-extreme-gen2 =
      self.nixosConfigurations.petrkozorezov-x1-extreme-gen2.config.system.build.toplevel;

    nixosConfigurations = {
      petrkozorezov-x1-extreme-gen2 =
        nixpkgs.lib.nixosSystem {
          system  = "x86_64-linux";
          modules =
            [
              ./hardware
              ./petrkozorezov.profile.nix
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

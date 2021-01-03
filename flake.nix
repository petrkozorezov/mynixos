{
  description = "My NixOS configuration";

  inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    thinkpad-x1-extreme-gen2 =
      self.nixosConfigurations.thinkpad-x1-extreme-gen2.config.system.build.toplevel;
    image =
      self.nixosConfigurations.image.config.system.build.isoImage;

    nixosConfigurations = let
      home = {
          home-manager = {
            useGlobalPkgs       = true;
            useUserPackages     = true;
            users.petrkozorezov = import ./home;
          };
        };
      base = {
        # pin nixpkgs rev
        nix.registry.nixpkgs.flake = nixpkgs;
        # TODO refactor overlays logic
        # nixpkgs.overlays = [ nix.overlay ];
      };
    in {
      thinkpad-x1-extreme-gen2 =
        nixpkgs.lib.nixosSystem {
          system  = "x86_64-linux";
          modules =
            [
              base
              ./nix.nix
              ./hardware/thinkpad-x1-extreme-gen2.nix
              ./system
              home-manager.nixosModules.home-manager
              home
            ];
        };

      image =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [
              base
              # TODO move to
              "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
              "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
              ./image.nix
              ./system
              home-manager.nixosModules.home-manager
              home
            ];
        };
    };
  };
}

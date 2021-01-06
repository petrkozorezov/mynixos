{
  description = "My NixOS configuration";

  inputs = {
         nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:rycee/home-manager";
          nixops.url = "github:NixOS/nixops";
  };

  outputs = { self, home-manager, nixpkgs, nixops, ... }:
    let
      revision = { system.configurationRevision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}"; };
    in
    {
      thinkpad-x1-extreme-gen2 =
        self.nixosConfigurations.thinkpad-x1-extreme-gen2.config.system.build.toplevel;
      mbp13 = self.nixosConfigurations.mbp13.config.system.build.toplevel;
      installer = self.nixosConfigurations.installer.config.system.build.isoImage;
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
                revision
                base
                ./nix.nix
                ./hardware/thinkpad-x1-extreme-gen2.nix
                ./secrets/users.nix
                ./system
                home-manager.nixosModules.home-manager
                home
              ];
          };

        mbp13 =
          nixpkgs.lib.nixosSystem {
            system  = "x86_64-linux";
            modules =
              [
                revision
                base
                ./nix.nix
                ./hardware/mbp13.nix
                ./secrets/users.nix
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
                revision
                base
                # TODO move to image.nix somehow
                "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
                "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
                ./image.nix
                ./secrets/users.nix
                ./system
                home-manager.nixosModules.home-manager
                home
              ];
          };
        installer =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [
                revision
                # TODO dvorak :)
                # TODO move to installer/iso.nix somehow
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                ./installer/iso.nix
              ];
          };
      };
      nixopsConfigurations = {
        default = {
          inherit nixpkgs;
        } // import ./router // revision;
      };

      # for 'nix shell -c nixops create --name router --flake .'
      defaultPackage.x86_64-linux = nixops.defaultPackage.x86_64-linux;
  };
}

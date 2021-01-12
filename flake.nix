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
        baseModules = [
          revision
          base
          ./nix.nix
          ./secrets
          ./system
          home-manager.nixosModules.home-manager
          home
        ];
      in {
        thinkpad-x1-extreme-gen2 =
          nixpkgs.lib.nixosSystem {
            system  = "x86_64-linux";
            modules = [ ./hardware/thinkpad-x1-extreme-gen2.nix ] ++ baseModules;
          };

        mbp13 =
          nixpkgs.lib.nixosSystem {
            system  = "x86_64-linux";
            modules = [ ./hardware/mbp13.nix ] ++ baseModules;
          };

        image =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
              "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" # TODO move to image.nix
            ] ++ baseModules;
          };
        installer =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [
                revision
                # TODO dvorak :)
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" # TODO move to installer/iso.nix
                ./installer/iso.nix
              ];
          };
      };
      nixopsConfigurations = {
        default = {
          inherit nixpkgs;
        } // import ./servers;
      };

      # FIXME
      # for 'nix shell -c nixops create --name router --flake .'
      defaultPackage.x86_64-linux = nixops.defaultPackage.x86_64-linux;
  };
}

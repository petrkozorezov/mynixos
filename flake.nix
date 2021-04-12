{
  description = "My NixOS configuration";

  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:rycee/home-manager"          ;
    nixops-plugged.url = "github:lukebfox/nixops-plugged"     ;
             utils.url = "github:numtide/flake-utils"         ;
  };

  outputs = { self, home-manager, nixpkgs, nixops-plugged, utils, ... }:
    let
      revision = { system.configurationRevision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}"; };
    in
    {
      thinkpad-x1-extreme-gen2 = self.nixosConfigurations.thinkpad-x1-extreme-gen2.config.system.build.toplevel;
      mbp13                    = self.nixosConfigurations.mbp13                   .config.system.build.toplevel;
      asrock-x300              = self.nixosConfigurations.asrock-x300             .config.system.build.toplevel;
      installer                = self.nixosConfigurations.installer               .config.system.build.isoImage;
      image                    = self.nixosConfigurations.image                   .config.system.build.isoImage;

      nixosConfigurations = let
        home = {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              users.petrkozorezov = import ./home;
            };
          };
        baseModules = [
          revision
          # TODO refactor overlays logic
          # nixpkgs.overlays = [ nix.overlay ];
          { nix.registry.nixpkgs.flake = nixpkgs; }
          ./nix.nix
          ./secrets
          ./system
          home-manager.nixosModules.home-manager
          home
        ];
      in {
        # TODO remove copy-paste
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

        asrock-x300 =
          nixpkgs.lib.nixosSystem {
            system  = "x86_64-linux";
            modules = [ ./hardware/asrock-x300.nix ] ++ baseModules;
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
                ./secrets
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
      defaultPackage.x86_64-linux = nixops-plugged.packages.x86_64-linux.nixops-hetznercloud;
  };
}

{
  description = "My NixOS configuration";

  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:rycee/home-manager"          ;
       flake-utils.url = "github:numtide/flake-utils"         ;
         deploy-rs.url = "github:serokell/deploy-rs"          ;
  };

  outputs = { self, home-manager, nixpkgs, deploy-rs, flake-utils, ... }:
    # TODO flake-utils.lib.eachDefaultSystem (system:
    let
      revision = { system.configurationRevision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}"; };
      system   = "x86_64-linux";
      pkgs     = nixpkgs.outputs.legacyPackages.${system};
      myNixOSSystem =
        modules:
          nixpkgs.lib.nixosSystem {
            system  = system;
            modules = [
              revision
              # TODO refactor overlays logic
              # nixpkgs.overlays = [ nix.overlay ];
              { nix.registry.nixpkgs.flake = nixpkgs; nixpkgs = (import ./nixpkgs.nix); }
              ./nix.nix
              ./secrets
              ./system
            ] ++ modules;
          };
      activateNixOS =
        configuration:
          deploy-rs.lib.${system}.activate.nixos configuration;
      activateHomeManager =
        configuration:
          deploy-rs.lib.${system}.activate.custom (configuration).activationPackage "$PROFILE/activate";
    in
    rec {
      # for nix shell
      # TODO migrate to mkShell
      defaultPackage.${system} = deploy-rs.packages.${system}.deploy-rs;

      nixosConfigurations = {
        thinkpad-x1-extreme-gen2 = myNixOSSystem [ ./hardware/thinkpad-x1-extreme-gen2.nix ];
        mbp13                    = myNixOSSystem [ ./hardware/mbp13.nix ];
        asrock-x300              = myNixOSSystem [ ./hardware/asrock-x300.nix ];

        # FIXME add home-manager profile
        # image = myNixOSSystem [
        #   "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
        #   "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" # TODO move to image.nix
        # ];

        installer =
          nixpkgs.lib.nixosSystem {
            system = system;
            modules =
              [
                revision
                ./secrets
                # TODO dvorak :)
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" # TODO move to installer/iso.nix
                ./installer/iso.nix
              ];
          };

        router =
          nixpkgs.lib.nixosSystem {
            system = system;
            modules = [
              revision
              { nix.registry.nixpkgs.flake = nixpkgs; nixpkgs = (import ./nixpkgs.nix); }
              ./nix.nix
              ./modules
              ./secrets
              ./servers/router.nix
              ./hardware/router.nix
            ];
          };
      };

    # FIXME remove copy/paste
    homeManagerConfigurations = {
      petrkozorezov =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs system;
          homeDirectory = "/home/petrkozorezov";
          username      = "petrkozorezov";
          configuration = ./home;
        };
    };

    deploy = {
      sshUser = "root";
      nodes = {
        asrock-x300 = {
          hostname = "asrock-x300";
          profiles = {
            system = {
              user = "root";
              path = activateNixOS self.nixosConfigurations.asrock-x300;
            };
            petrkozorezov = {
              user = "petrkozorezov";
              path = activateHomeManager self.homeManagerConfigurations.petrkozorezov;
            };
          };
        };
        router = {
          hostname = "router";
          profiles = {
            system = {
              user = "root";
              path = activateNixOS self.nixosConfigurations.router;
            };
          };
        };
      };
    };

    checks = deploy-rs.lib.${system}.deployChecks self.deploy;
  };
}

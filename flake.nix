{
  description = "My NixOS configuration";

  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:rycee/home-manager"          ;
       flake-utils.url = "github:numtide/flake-utils"         ;
         deploy-rs.url = "github:serokell/deploy-rs"          ;
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs"        ;
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, deploy-rs, nix-doom-emacs, ... }:
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
              ./modules
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
      defaultPackage.${system} =
        let
          pkgs = nixpkgs.legacyPackages.${system};
          terraform =
            pkgs.terraform_0_15.withPlugins (tp: [
              tp.hcloud
            ]);
        in pkgs.buildEnv {
          name  = "zoo-shell";
          paths = [
            deploy-rs.packages.${system}.deploy-rs
            terraform
            pkgs.terranix
          ];
        };

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
          homeDirectory    = "/home/petrkozorezov";
          username         = "petrkozorezov";
          configuration    = ./home;
          extraSpecialArgs = { inherit nix-doom-emacs; };
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

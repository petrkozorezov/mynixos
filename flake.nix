{
  description = "My NixOS configuration";

  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05"       ;
      home-manager.url = "github:rycee/home-manager/release-21.05";
               nur.url = "github:nix-community/NUR"               ;
         deploy-rs.url = "github:serokell/deploy-rs"              ;
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs"            ;
    # sometimes version of emacs-overlay in nix-doom-emacs lock file is outdated
    # and some packages are not building
    nix-doom-emacs.inputs.emacs-overlay = {
      url   = "github:nix-community/emacs-overlay";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, nix-doom-emacs, nur, ... }:
    let
      # high level system description
      system = "x86_64-linux";
      nodes =
        let
          petrkozorezov = { petrkozorezov = [ "petrkozorezov" ]; };
        in {
          mbp13       = { system = [ "hardware/mbp13.nix"         "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/mbp13.nix"       ]; } // petrkozorezov;
          asrock-x300 = { system = [ "hardware/asrock-x300.nix"   "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/asrock-x300.nix" ]; } // petrkozorezov;
          router      = { system = [ "hardware/router.nix"        "base.nix" "machines/router.nix"    ]; };
          helsinki1   = { system = [ "hardware/hetzner-cloud.nix" "base.nix" "machines/helsinki1.nix" ]; };
        };

      mapProfiles =
        systemMapF: userMapF: hostName:
          builtins.mapAttrs (
            profileName:
              if profileName == "system" then
                systemMapF hostName
              else
                userMapF profileName
          );
    in rec {
      packages = nixpkgs.legacyPackages;

      #
      # development & deployment shell
      #
      defaultPackage.${system} =
        let
          pkgs = packages.${system};
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

      #
      # configurations
      # construct `{ hostname = { profile = configuration } }`
      #
      configs =
        let
          relativePaths = basePath: map (path: ./. + ("/" + basePath + ("/" + path))); # Am I do smth wrong with paths?
          nixpkgsConfig = (import ./nixpkgs.nix);
          nixpkgsConfigMod = { nixpkgs = (nixpkgsConfig // { overlays = nixpkgsConfig.overlays ++ [ nur.overlay ]; }); };
          systemConfig =
            hostName: modules:
              nixpkgs.lib.nixosSystem {
                system  = system;
                modules = [
                  {
                    system.configurationRevision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}";
                    networking.hostName = hostName;
                    nix.registry.nixpkgs.flake = nixpkgs;
                  }
                  nixpkgsConfigMod
                  ./system/modules
                  ./nix.nix
                  ./secrets
                  # (modulesPath + "/profiles/hardened.nix")
                  ({ config, ... }: {
                    services.openssh.enable = true;
                    users.users.root.openssh.authorizedKeys.keys = [ config.zoo.secrets.deployment.authPublicKey ];
                  })
                ] ++ relativePaths "system/profiles" modules;
              };
          userConfig =
            userName: modules:
              home-manager.lib.homeManagerConfiguration {
                pkgs             = packages.${system};
                system           = system;
                homeDirectory    = "/home/" + userName;
                username         = userName;
                configuration    = {};
                extraSpecialArgs = { inherit nix-doom-emacs nur; }; # TODO find out more general way to import
                extraModules     = [
                  nixpkgsConfigMod
                  ./home/modules
                  ./secrets
                ] ++ relativePaths "home/profiles" modules;
              };
        in
          builtins.mapAttrs (mapProfiles systemConfig userConfig) nodes;

      #
      # system configuration for `nixos-rebuild`
      # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
      # λ nixos-rebuild --flake .#<hostname> build
      #
      nixosConfigurations =
        builtins.mapAttrs (_: profiles: profiles.system) configs;

      #
      # deploy-rs specs
      # λ deploy ".#configs."<hostname>".system.config.system.build.toplevel"
      #
      deploy = let
        activateHomeManager =
          configuration:
            deploy-rs.lib.${system}.activate.custom (configuration).activationPackage "$PROFILE/activate";
        activateSystem =
          deploy-rs.lib.${system}.activate.nixos;

        systemProfile =
          hostName: configuration:
            {
              user = "root";
              path = activateSystem configuration;
            };
        userProfile =
          userName: configuration:
          {
            user = userName;
            path = activateHomeManager configuration;
          };
        host =
          hostName: profiles:
            {
              hostname = hostName;
              profiles = mapProfiles systemProfile userProfile hostName profiles;
            };
      in
        {
          sshUser = "root";
          nodes = builtins.mapAttrs host configs;
        };

      checks = deploy-rs.lib.${system}.deployChecks self.deploy;
    };
}

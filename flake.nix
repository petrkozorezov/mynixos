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
    nix-doom-emacs.inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, nix-doom-emacs, nur, ... }:
    let
      # high level system description
      system   = "x86_64-linux";
      packages = nixpkgs.legacyPackages;
      nodes =
        let
          relativePaths = basePath: map (path: ./. + ("/" + basePath + ("/" + path)));
          hmPaths       = relativePaths "home/profiles";
          sysPaths      = relativePaths "system/profiles";
          users         = { petrkozorezov = hmPaths [ "petrkozorezov" ]; };
        in {
          mbp13       = { system = sysPaths [ "hardware/mbp13.nix"         "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/mbp13.nix"       ]; } // users;
          asrock-x300 = { system = sysPaths [ "hardware/asrock-x300.nix"   "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/asrock-x300.nix" ]; } // users;
          router      = { system = sysPaths [ "hardware/router.nix"        "base.nix" "machines/router.nix"    ]; };
          helsinki1   = { system = sysPaths [ "hardware/hetzner-cloud.nix" "base.nix" "machines/helsinki1.nix" ]; };
          test-vm     = { system = sysPaths [ "base.nix" "petrkozorezov.nix" "workstation.nix" ] ++ [(nixpkgs + /nixos/modules/profiles/qemu-guest.nix)]; } // users;
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

      baseSystemModule =
        hostName:
          { config, ... }: {
            system.configurationRevision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}";
            networking.hostName = hostName;
            nix.registry.nixpkgs.flake = nixpkgs;
            services.openssh = {
              enable                 = true;
              passwordAuthentication = false;
              # ports                  = [ 42 ];
            };
            users.users.root.openssh.authorizedKeys.keys = [ config.zoo.secrets.deployment.authPublicKey ];
          };
      nixpkgsConfigModule =
        {
          nixpkgs =
            let
              nixpkgsConfig = (import ./nixpkgs.nix);
            in
              (nixpkgsConfig // { overlays = nixpkgsConfig.overlays ++ [ nur.overlay ]; });
        };
      systemConfig =
        hostName: modules:
          nixpkgs.lib.nixosSystem {
            system  = system;
            modules = [
              (baseSystemModule hostName)
              nixpkgsConfigModule
              ./system/modules
              ./nix.nix
              ./secrets
              # (modulesPath + "/profiles/hardened.nix")
            ] ++ modules;
          };

      sharedHMModules =
        [
          ./home/modules
          ./secrets
        ];
      extraHMSpecialArgs = { inherit nix-doom-emacs nur; };
      userConfig =
        userName: modules:
          home-manager.lib.homeManagerConfiguration {
            pkgs             = packages.${system};
            system           = system;
            homeDirectory    = "/home/" + userName;
            username         = userName;
            configuration    = { imports = [ nixpkgsConfigModule ] ++ sharedHMModules ++ modules; };
            extraSpecialArgs = extraHMSpecialArgs;
          };

      hmInitModule =
        userName: modules:
          {
            home-manager = {
              useGlobalPkgs     = true;
              useUserPackages   = true;
              users.${userName} = { imports = modules; };
              sharedModules     = sharedHMModules;
              extraSpecialArgs  = extraHMSpecialArgs;
            };
          };
    in rec {
      inherit packages;

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
        builtins.mapAttrs (mapProfiles systemConfig userConfig) nodes;

      #
      # system configuration for `nixos-rebuild`
      # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
      # λ nixos-rebuild --flake .#<hostname> build
      #
      nixosConfigurations =
        builtins.mapAttrs
          (
            hostName: profiles:
              let
                systemProfile  = profiles.system;
                usersProfiles  = removeAttrs profiles [ "system" ];
                usersHMModules = builtins.attrValues (builtins.mapAttrs hmInitModule usersProfiles);
              in
                systemConfig hostName (systemProfile ++ [ home-manager.nixosModules.home-manager ] ++ usersHMModules)
          )
          nodes;

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
          # sshOpts = [ "-p" "42" ];
          nodes   = builtins.mapAttrs host configs;
        };

      checks = deploy-rs.lib.${system}.deployChecks self.deploy;
    };
}

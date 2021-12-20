{
  description = "My NixOS configuration";

  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11"       ;
      home-manager.url = "github:rycee/home-manager/release-21.11";
               nur.url = "github:nix-community/NUR"               ;
         deploy-rs.url = "github:serokell/deploy-rs"              ;
          terranix.url = "github:terranix/terranix"               ;
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs"            ;
               dns.url = "github:kirelagin/dns.nix"               ;
    # sometimes version of emacs-overlay in nix-doom-emacs lock file is outdated
    # and some packages are not building
    # an explicitly input is needed here to prevent emacs-overlay from auto update
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, deploy-rs, terranix, nur, ... }@inputs:
    let
      # high level system description
      system   = "x86_64-linux";
      overlays = (import ./system/profiles/nixpkgs.nix { inherit inputs; }).nixpkgs.overlays;
      pkgs     = import nixpkgs { inherit system overlays; };
      nodes =
        let
          relativePaths = basePath: map (path: ./. + ("/" + basePath + ("/" + path)));
          hmPaths       = relativePaths "home/profiles";
          sysPaths      = relativePaths "system/profiles";
          users         = { petrkozorezov = hmPaths [ "petrkozorezov" ]; };
        in {
          mbp13       = { system = sysPaths [ "hardware/mbp13.nix"         "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/mbp13.nix"       ]; } // users;
          asrock-x300 = { system = sysPaths [ "hardware/asrock-x300.nix"   "base.nix" "petrkozorezov.nix" "workstation.nix" "machines/asrock-x300.nix" ]; } // users;
          router      = { system = sysPaths [ "hardware/router.nix"        "base.nix" "petrkozorezov.nix" "machines/router.nix"    ]; };
          helsinki1   = { system = sysPaths [ "hardware/hetzner-cloud.nix" "base.nix" "petrkozorezov.nix" "machines/helsinki1.nix" ]; };
        };

      mapProfiles =
        systemMapF: userMapF: hostname:
          builtins.mapAttrs (
            profileName:
              if profileName == "system" then
                systemMapF hostname
              else
                userMapF profileName
          );

      # self lib
      # TODO find a better way
      slib = import ./lib { inherit slib; inherit (nixpkgs) lib; };
      configExtraAgrs = { inherit system inputs slib; };
      systemConfig =
        hostname: modules:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              { networking.hostName = hostname; }
              ./system/modules
              ./system/profiles/nix.nix
              ./system/profiles/nixpkgs.nix
              ./secrets
            ] ++ modules;
            extraArgs = configExtraAgrs;
          };

      sharedHMModules =
        [
          ./home/modules
          ./secrets
        ];
      userConfig =
        username: modules:
          home-manager.lib.homeManagerConfiguration {
            inherit system pkgs username;
            homeDirectory    = "/home/" + username;
            configuration    = { imports = [ ./system/profiles/nixpkgs.nix ] ++ sharedHMModules ++ modules; };
            extraSpecialArgs = configExtraAgrs;
          };

      hmInitModule =
        username: modules:
          {
            home-manager = {
              useGlobalPkgs     = true;
              useUserPackages   = true;
              users.${username} = { imports = modules; };
              sharedModules     = sharedHMModules;
              extraSpecialArgs  = configExtraAgrs;
            };
          };
    in rec {
      legacyPackages."${system}" = pkgs;
      # inherit overlays;

      #
      # development & deployment shell
      #
      defaultPackage.${system} =
        let
          terraform =
            pkgs.terraform_0_15.withPlugins (tp: [
              tp.hcloud
            ]);
        in pkgs.buildEnv {
          name  = "zoo-shell";
          paths = [
            deploy-rs.packages.${system}.deploy-rs
            terraform
            terranix.defaultPackage.${system}
            pkgs.ripgrep
            pkgs.nur.repos.rycee.firefox-addons-generator
          ];
        };

      # terraform bindings
      # allows to run only one command (eg `nix run .#tf.plan`)
      tf = let
        terraformConfiguration =
          terranix.lib.terranixConfiguration {
            inherit system;
            modules = [ ./cloud ];
          };
        tapp = name: code:
          {
            type = "app";
            program = toString (pkgs.writers.writeBash name (''
              set -ex
              if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
              cp ${terraformConfiguration} config.tf.json
            '' + code));
          };
        tfapp = cmd: tapp ("tf" + cmd) ("terraform " + cmd);
      in {
        gen     = tapp "tfgen" "";
        init    = tfapp "init"   ;
        plan    = tfapp "plan"   ;
        apply   = tfapp "apply"  ;
        destroy = tfapp "destroy";
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
            hostname: profiles:
              let
                systemProfile  = profiles.system;
                usersProfiles  = removeAttrs profiles [ "system" ];
                usersHMModules = builtins.attrValues (builtins.mapAttrs hmInitModule usersProfiles);
              in
                systemConfig hostname (systemProfile ++ [ home-manager.nixosModules.home-manager ] ++ usersHMModules)
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
          hostname: configuration:
            {
              user = "root";
              path = activateSystem configuration;
            };
        userProfile =
          username: configuration:
          {
            user = username;
            path = activateHomeManager configuration;
          };
        host =
          hostname: profiles:
            {
              hostname = hostname;
              profiles = mapProfiles systemProfile userProfile hostname profiles;
            };
      in
        {
          sshUser = "root";
          nodes   = builtins.mapAttrs host configs;
        };

      # FIXME
      # checks = deploy-rs.lib.${system}.deployChecks self.deploy;

      # lib
      lib = slib;

      # tests
      tests = let
        args =
            {
              inherit inputs pkgs;
              lib      = nixpkgs.lib;
              testing  = import (nixpkgs + /nixos/lib/testing-python.nix) {
                inherit pkgs system;
                specialArgs         = configExtraAgrs;
                extraConfigurations = [ ./system/modules ];
              };
            };
      in pkgs.testing.addTestAll {
        system = import ./system/tests args;
      };

    };
}

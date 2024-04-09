{
  description = "My NixOS configuration";

  inputs.deps.url = "path:./deps";

  outputs = { self, deps, ... }:
    let
      inputs = deps.inputs // {self = deps;};
      inherit (inputs) nixpkgs home-manager deploy-rs;
      # high level system description
      system = "x86_64-linux";
      pkgs   = deps.legacyPackages.${system};
      nodes  =
        let
          relativePaths = basePath: map (path: ./. + ("/" + basePath + ("/" + path)));
          hmPaths       = relativePaths "home/profiles";
          sysPaths      = relativePaths "system/profiles";
          users         = { petrkozorezov = hmPaths [ "petrkozorezov" ]; };
        in {
          mbp13       = { system = sysPaths [ "machines/mbp13.nix"       "users/petrkozorezov.nix" ]; } // users;
          asrock-x300 = { system = sysPaths [ "machines/asrock-x300.nix" "users/petrkozorezov.nix" ]; } // users;
          router      = { system = sysPaths [ "machines/router.nix"      ]; };
          helsinki1   = { system = sysPaths [ "machines/helsinki1.nix"   ]; };
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
      configExtraAgrs = { inherit self system slib deps; };
      commonModules = [ ./modules deps.module.${system} ./secrets ];
      systemConfig =
        hostname: modules:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [ { networking.hostName = hostname; _module.args = configExtraAgrs; } ] ++ commonModules ++ [ ./system/modules ] ++ modules;
          };

      commonHMModules = commonModules ++ [ ./home/modules ];
      userConfig =
        username: modules:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = commonHMModules ++ modules ++ [{
              home = {
                inherit username;
                homeDirectory = "/home/" + username;
              };
            }];
            extraSpecialArgs = configExtraAgrs;
          };

      hmInitModule =
        username: modules:
          {
            home-manager = {
              useGlobalPkgs       = true;
              useUserPackages     = true;
              users.${username}   = { imports = modules; };
              sharedModules       = commonHMModules;
              extraSpecialArgs    = configExtraAgrs;
              backupFileExtension = ".bak";
            };
          };
    in rec {
      # dev shell
      devShell."${system}" = inputs.devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [ ./devenv.nix ];
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
              inherit deps pkgs;
              lib      = nixpkgs.lib;
              testing  = import (nixpkgs + /nixos/lib/testing-python.nix) {
                inherit pkgs system;
                specialArgs         = configExtraAgrs;
                extraConfigurations = [ ./modules ./system/modules ];
              };
            };
      in pkgs.testing.addTestAll {
        system = import ./system/tests args;
      };

    };
}

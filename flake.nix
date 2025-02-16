{
  description = "My NixOS configuration";

  inputs.deps.url = "path:./deps";

  outputs = { self, deps, ... }:
    let
      inputs = deps.inputs // { self = deps; };
      inherit (inputs) nixpkgs home-manager deploy-rs;
      buildSystem = "x86_64-linux"; # FIXME hardcode
      legacyPackages = deps.legacyPackages;
      commonModules = [
        ./modules
        ./secrets
      ];
      commonNixosModules = system: commonModules ++ [
        deps.module.${system} # nixpkgs: system, config, etc...
      ];
      commonHMModules = username: commonModules ++ [
        inputs.stylix.homeManagerModules.stylix
        ./secrets/home
        ./home/modules
        {
          home = {
            inherit username;
            homeDirectory = "/home/" + username;
          };
        }
      ];

      # high level hosts description
      hostsModules =
        let
          relPaths   = basePath: map (path: ./. + ("/" + basePath + ("/" + path)));
          hmPaths    = relPaths "home/profiles";
          nixosPaths = relPaths "system/profiles";
          hmModule   = username: {
            home-manager = {
              users.${username}   = { imports = hmPaths [ username ]; };
              sharedModules       = commonHMModules username;
              extraSpecialArgs    = configExtraAgrs;
              backupFileExtension = ".bak";
              useGlobalPkgs       = true;
              useUserPackages     = false;
            };
          };
        in {
          mbp13 = {
            system = "x86_64-linux";
            profiles.system =
              (nixosPaths [ "machines/mbp13.nix" "users/petrkozorezov.nix" ]) ++
              [ home-manager.nixosModules.home-manager (hmModule "petrkozorezov") ];
          };
          asrock-x300 = {
            system = "x86_64-linux";
            profiles.system =
              (nixosPaths [ "machines/asrock-x300.nix" "users/petrkozorezov.nix" ]) ++
              [ home-manager.nixosModules.home-manager (hmModule "petrkozorezov") ];
          };
          router = {
            system = "x86_64-linux";
            profiles.system = nixosPaths [ "machines/router.nix" ];
          };
          srv1 = {
            system = "aarch64-linux";
            profiles.system = nixosPaths [ "machines/srv1.nix" ];
          };
        };

      # self lib
      # TODO find a better way
      slib = import ./lib { inherit slib; inherit (nixpkgs) lib; };
      configExtraAgrs = { inherit self slib deps; };

      mapHostProfiles =
        nixosMapF: hmMapF: hostname: host:
          {
            system = host.system;
            profiles =
              builtins.mapAttrs (
                profileName:
                  if profileName == "system"
                    then nixosMapF host.system hostname
                    else hmMapF host.system profileName
              ) host.profiles;
          };
    in rec {
      #
      # dev shell
      #
      devShell.${buildSystem} = inputs.devenv.lib.mkShell {
        inherit inputs;
        pkgs    = legacyPackages.${buildSystem};
        modules = [ ./devenv.nix ];
      };

      #
      # configurations
      # `{ ${hostname} = { system = ${system}; profiles = { ${profile} = ${configuration}; }; }; }`
      # λ nix build .#configurations.$*.profiles.system.config.system.build.toplevel
      #
      configurations = let
        nixosConfig =
          system: hostname: modules:
            nixpkgs.lib.nixosSystem {
              inherit system;
              modules =
                [ {
                  networking.hostName = hostname;
                  _module.args = configExtraAgrs;
                } ] ++
                (commonNixosModules system) ++ [
                  ./system/modules
                ] ++
                modules;
            };
        hmConfig =
          system: username: modules:
            home-manager.lib.homeManagerConfiguration {
              pkgs             = legacyPackages.${system};
              modules          = (commonHMModules username) ++ modules;
              extraSpecialArgs = configExtraAgrs;
            };
      in
        builtins.mapAttrs (mapHostProfiles nixosConfig hmConfig) hostsModules;

      #
      # system configuration for `nixos-rebuild`
      # nixosConfigurations.${hostname}.config.system.build.toplevel must be a derivation
      # λ nixos-rebuild --flake ".#${hostname}" build
      #
      nixosConfigurations =
        builtins.mapAttrs (_: host: host.profiles.system) configurations;

      #
      # home-manager configuration for `home-manager`
      # nixosConfigurations.${hostname}.config.system.build.toplevel must be a derivation
      # λ home-manager --flake ".#${hostname}.${username}" build
      #
      homeConfigurations =
        builtins.mapAttrs (_: host:
          builtins.mapAttrs (_: configuration: configuration) (removeAttrs host.profiles [ "system" ])
        ) configurations;

      #
      # deploy-rs specs
      # λ deploy ".#${hostname}.system"
      # λ deploy ".#${hostname}.${username}"
      #
      deploy = let
        activateNixos =
          system: configuration:
            legacyPackages.${system}.deploy-rs.lib.activate.nixos configuration;
        activateHm =
          system: configuration:
            legacyPackages.${system}.deploy-rs.lib.activate.custom (configuration).activationPackage "$PROFILE/activate";
        nixosProfile =
          system: hostname: configuration: {
            user = "root";
            path = activateNixos system configuration;
          };
        hmProfile =
          system: username: configuration: {
            user = username;
            path = activateHm system configuration;
          };
        host =
          hostname: host: {
            hostname = hostname;
            profiles = (mapHostProfiles nixosProfile hmProfile hostname host).profiles;
          };
      in {
        sshUser = "root";
        nodes   = builtins.mapAttrs host configurations;
        # fastConnection = true;
      };

      # FIXME
      # checks = deploy-rs.lib.${buildSystem}.deployChecks self.deploy;

      # lib
      lib = slib;

      # tests
      tests = let
        system = buildSystem;
        pkgs = legacyPackages.${system};
        runTest =
          testFile:
            pkgs.testers.runNixOSTest {
              imports = [ testFile ];
              node.specialArgs = configExtraAgrs;
              extraBaseModules = { imports = [ ./modules ./system/modules ]; };
            };
        addTestAll =
          tests:
            # fake package that builds all tests as nativeBuildInputs
            pkgs.callPackage (
              { pkgs, lib, stdenv, ... }:
                (tests // {
                  all = (pkgs.stdenv.mkDerivation {
                    name              = "tests-all";
                    phases            = [ "fakeBuildPhase" ];
                    fakeBuildPhase    = "echo true > $out";
                    nativeBuildInputs = map (test: if lib.isDerivation test then test else test.all) (lib.attrValues tests);
                  });
                })
              ) {};
      in addTestAll {
        system = import ./system/tests { inherit runTest addTestAll; };
      };
    };
}

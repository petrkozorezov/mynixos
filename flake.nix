{
  description = "My NixOS configuration";

  inputs.deps.url = "path:./deps";

  outputs = { self, deps, ... }:
    let
      inputs = deps.inputs // { self = deps; };
      inherit (inputs) nixpkgs home-manager deploy-rs;
      buildSystem = "x86_64-linux"; # FIXME hardcode
      legacyPackages = deps.legacyPackages;

      # high level hosts description
      hosts =
        let
          relPaths   = basePath: map (path: ./. + ("/" + basePath + ("/" + path)));
          hmPaths    = relPaths "home/profiles";
          nixosPaths = relPaths "system/profiles";
        in {
          mbp13 = {
            system = "x86_64-linux";
            profiles = {
              system = nixosPaths [ "machines/mbp13.nix" "users/petrkozorezov.nix" ];
              petrkozorezov = hmPaths [ "petrkozorezov" ];
            };
          };
          asrock-x300 = {
            system = "x86_64-linux";
            profiles = {
              system = nixosPaths [ "machines/asrock-x300.nix" "users/petrkozorezov.nix" ];
              petrkozorezov = hmPaths [ "petrkozorezov" ];
            };
          };
          router = {
            system = "x86_64-linux";
            profiles = {
              system = nixosPaths [ "machines/router.nix" ];
            };
          };
          srv1 = {
            system = "aarch64-linux";
            profiles = {
              system = nixosPaths [ "machines/srv1.nix" ];
            };
          };
        };

      mapHostProfiles =
        nixosMapF: hmMapF: hostname: host:
          {
            system = host.system;
            profiles =
              builtins.mapAttrs (
                profileName:
                  if profileName == "system" then
                    nixosMapF host.system hostname
                  else
                    hmMapF host.system profileName
              ) host.profiles;
          };

      # self lib
      # TODO find a better way
      slib = import ./lib { inherit slib; inherit (nixpkgs) lib; };
      configExtraAgrs = { inherit self slib deps; };
      commonModules = system: [
        deps.module.${system} # nixpkgs: system, config, etc...
        ./modules
        ./secrets
      ];
      nixosConfig =
        system: hostname: modules:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules =
              [ {
                networking.hostName = hostname;
                _module.args = configExtraAgrs;
              } ] ++
              (commonModules system) ++ [
                inputs.stylix.nixosModules.stylix
                ./system/modules
              ] ++
              modules;
          };

      commonHMModules = system: (commonModules system) ++ [
        inputs.stylix.homeManagerModules.stylix
        ./home/modules
      ];
      hmConfig =
        system: username: modules:
          home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages.${system};
            modules = (commonHMModules system) ++ modules ++ [{
              home = {
                inherit username;
                homeDirectory = "/home/" + username;
              };
            }];
            extraSpecialArgs = configExtraAgrs;
          };
    in rec {
      #
      # dev shell
      #
      devShell.${buildSystem} = inputs.devenv.lib.mkShell {
        inherit inputs;
        pkgs = legacyPackages.${buildSystem};
        modules = [ ./devenv.nix ];
      };

      #
      # configurations
      # `{ ${hostname} = { system = ${system}; profiles = { ${profile} = ${configuration}; }; }; }`
      # λ nix build .#configs.$*.profiles.system.config.system.build.toplevel
      #
      configs =
        builtins.mapAttrs (mapHostProfiles nixosConfig hmConfig) hosts;

      #
      # system configuration for `nixos-rebuild`
      # nixosConfigurations.${hostname}.config.system.build.toplevel must be a derivation
      # λ nixos-rebuild --flake ".#${hostname}" build
      #
      nixosConfigurations = let
        hmInitModule =
          system: username: modules:
            {
              home-manager = {
                useGlobalPkgs       = false;
                useUserPackages     = true;
                users.${username}   = { imports = modules; };
                sharedModules       = commonHMModules system;
                extraSpecialArgs    = configExtraAgrs;
                backupFileExtension = ".bak";
              };
            };
      in
        builtins.mapAttrs
          (
            hostname: host:
              let
                nixosProfile = host.profiles.system;
                hmProfiles   = removeAttrs host.profiles [ "system" ];
                hmModules    = builtins.attrValues (builtins.mapAttrs (hmInitModule host.system) hmProfiles);
              in
                nixosConfig hostname (nixosProfile ++ [ home-manager.nixosModules.home-manager ] ++ hmModules)
          )
          hosts;

      #
      # deploy-rs specs
      # λ deploy ".#configs.${hostname}.system.config.system.build.toplevel"
      #
      deploy = let
        activateNixos =
          system: configuration:
            legacyPackages.${system}.deploy-rs.lib.activate.nixos configuration;
        activateHm =
          system: configuration:
            legacyPackages.${system}.deploy-rs.lib.activate.custom (configuration).activationPackage "$PROFILE/activate";

        nixosProfile =
          system: hostname: configuration:
            {
              user = "root";
              path = activateNixos system configuration;
            };
        hmProfile =
          system: username: configuration:
            {
              user = username;
              path = activateHm system configuration;
            };

        host =
          hostname: host:
            {
              hostname = hostname;
              profiles = (mapHostProfiles nixosProfile hmProfile hostname host).profiles;
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


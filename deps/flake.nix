# The main reason to have this separation is
# to be able to store nixpkgs with deps on disk without the secrets
{
  description = "My Nix Packages";
  # TODO remove copy/paste (https://github.com/NixOS/nix/issues/3966)
  inputs = {
               # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"     ;
               nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11"        ;
          home-manager.url = "github:rycee/home-manager/release-25.11" ;
          # home-manager.url = "github:rycee/home-manager"               ;
                stylix.url = "github:danth/stylix/release-25.11"       ;
                # stylix.url = "github:danth/stylix"                     ;
        firefox-addons.url = "github:petrkozorezov/firefox-addons-nix" ;
       arkenfox-userjs.url = "github:petrkozorezov/arkenfox-userjs-nix";
                devenv.url = "github:cachix/devenv/v1.11.1"            ;
             deploy-rs.url = "github:serokell/deploy-rs"               ;
           flake-utils.url = "github:numtide/flake-utils"              ;
                   dns.url = "github:kirelagin/dns.nix"                ; # TODO nix-community/dns.nix
    nix-index-database.url = "github:Mic92/nix-index-database"         ;
      firefox-csshacks.url = "github:MrOtherGuy/firefox-csshacks"      ;
            tt-schemes.url = "github:tinted-theming/schemes";

      firefox-csshacks.flake = false;
            tt-schemes.flake = false;

          home-manager.inputs.nixpkgs.follows = "nixpkgs";
                stylix.inputs.nixpkgs.follows = "nixpkgs";
        firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
                devenv.inputs.nixpkgs.follows = "nixpkgs";
             deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
                   dns.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              # FIXME
              # nix why-depends /nix/store/q1m61j78kfswwyvkh8nx37sgiww24hbm-home-manager-generation /nix/store/zi41h4x9rbym9q010p41lrh04y84lqyw-openssl-1.1.1w
              # sublime4 depends on it
              "openssl-1.1.1w"
            ];
            # TODO move it to hardware config
            # rocmSupport = true;
          };
          overlays = [
            inputs.firefox-addons.overlays.default
            inputs.devenv.overlays.default
            inputs.deploy-rs.overlays.default
            # this ~HACK~ code from deploy-rs docs to prevent deploy-rs building (it's annoying for aarch64)
            # (but it can lead to inconsistency)
            (prev: super: {
              deploy-rs = {
                deploy-rs = (import nixpkgs { inherit system config; }).deploy-rs;
                lib = super.deploy-rs.lib;
              };
            })
            (prev: super: let
              callPackage = name: super.callPackage (./overlay + ("/" + name))  { deps = self; };
            in {
              # just to ensure overlay works
              test = super.hello;
              bclmctl = callPackage "bclmctl.nix";
              firefox-addons-custom.tronlink = callPackage "tronlink.nix";
              mynixos.builders = callPackage "builders.nix";
            })
          ];
          nixpkgsOpts = { inherit system config overlays; };
          pkgs = import nixpkgs nixpkgsOpts;
        in rec {
          # TODO move it flake
          legacyPackages = pkgs;
          module.nixpkgs = nixpkgsOpts;
        }
    );
}

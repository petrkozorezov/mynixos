# The main reason to have this separation is
# to be able to store nixpkgs with deps on disk without the secrets
{
  description = "My Nix Packages";
  # TODO remove copy/paste (https://github.com/NixOS/nix/issues/3966)
  inputs = {
               nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"       ;
          home-manager.url = "github:rycee/home-manager/release-24.11";
                   nur.url = "github:nix-community/NUR"               ;
                devenv.url = "github:cachix/devenv/v1.3.1"            ;
             deploy-rs.url = "github:serokell/deploy-rs"              ;
           flake-utils.url = "github:numtide/flake-utils"             ;
                   dns.url = "github:kirelagin/dns.nix"               ;
    nix-index-database.url = "github:Mic92/nix-index-database"        ;

          home-manager.inputs.nixpkgs.follows = "nixpkgs";
                   nur.inputs.nixpkgs.follows = "nixpkgs";
                devenv.inputs.nixpkgs.follows = "nixpkgs";
             deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
           flake-utils.inputs.nixpkgs.follows = "nixpkgs";
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
            inputs.nur.overlays.default
            inputs.devenv.overlays.default
            inputs.deploy-rs.overlays.default
            # this ~HACK~ code from deploy-rs docs to prevent deploy-rs building (it's annoying for aarch64)
            # (but it can lead to inconsistency)
            (self: super: {
              deploy-rs = {
                deploy-rs = (import nixpkgs { inherit system config; }).deploy-rs;
                lib = super.deploy-rs.lib;
              };
            })
            (import ./overlay)
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

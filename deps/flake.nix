{
  description = "My Nix Packages";
  # TODO https://github.com/NixOS/nix/issues/3966
  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"                      ;
            devenv.url = "github:cachix/devenv/v0.6.3"                           ;
         deploy-rs.url = "github:serokell/deploy-rs"                             ;
       flake-utils.url = "github:numtide/flake-utils"                            ;
     nixos-channel.url = "https://nixos.org/channels/nixos-23.11/nixexprs.tar.xz";
      home-manager.url = "github:rycee/home-manager/release-23.11"               ;
               nur.url = "github:nix-community/NUR"                              ;
               dns.url = "github:kirelagin/dns.nix"                              ;
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          };
          overlays = [
            # TODO use a single common way
            inputs.nur.overlay
            inputs.fenix.overlays.default
            # TODO inputs.devenv.overlay
            (final: prev: { devenv = inputs.devenv.packages.${prev.system}.default; })
            (import ./overlay)
          ];
        in rec {
          legacyPackages = import nixpkgs { inherit system config overlays; };
          module.nixpkgs = { inherit system config overlays; };
        }
    );
}

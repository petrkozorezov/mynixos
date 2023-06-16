{
  description = "My Nix Packages";
  # TODO remove copy-paste
  # see https://github.com/NixOS/nix/issues/3966
  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"                      ;
       flake-utils.url = "github:numtide/flake-utils"                            ;
     nixos-channel.url = "https://nixos.org/channels/nixos-22.11/nixexprs.tar.xz";
      home-manager.url = "github:rycee/home-manager/release-22.11"               ;
               nur.url = "github:nix-community/NUR"                              ;
         deploy-rs.url = "github:serokell/deploy-rs"                             ;
          terranix.url = "github:terranix/terranix"                              ;
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs"                   ;
               dns.url = "github:kirelagin/dns.nix"                              ;
            devenv.url = "github:cachix/devenv/latest"                           ;
    # sometimes version of emacs-overlay in nix-doom-emacs lock file is outdated
    # and some packages are not building
    # an explicitly input is needed here to prevent emacs-overlay from auto update
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nur, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [ ];
          };
          overlays = [ nur.overlay fenix.overlays.default (import ./overlay) ];
        in rec {
          legacyPackages = import nixpkgs { inherit system config overlays; };
          module.nixpkgs = { inherit system config overlays; };
        }
    );
}

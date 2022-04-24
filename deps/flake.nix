{
  description = "My Nix Packages";
  # TODO remove copy-paste
  # see https://github.com/NixOS/nix/issues/3966
  inputs = {
           nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11"                      ;
     nixos-channel.url = "https://nixos.org/channels/nixos-21.11/nixexprs.tar.xz";
      home-manager.url = "github:rycee/home-manager/release-21.11"               ;
               nur.url = "github:nix-community/NUR"                              ;
         deploy-rs.url = "github:serokell/deploy-rs"                             ;
          terranix.url = "github:terranix/terranix"                              ;
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs"                           ;
               dns.url = "github:kirelagin/dns.nix"                              ;
    # sometimes version of emacs-overlay in nix-doom-emacs lock file is outdated
    # and some packages are not building
    # an explicitly input is needed here to prevent emacs-overlay from auto update
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.inputs.emacs-overlay.follows = "emacs-overlay";
  };

  outputs = { self, nixpkgs, nur, ... }:
    let
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.0.2u"
          "python2.7-cryptography-2.9.2"
        ];
      };
      overlays = [ nur.overlay (import ./overlay) ];
      system = "x86_64-linux";
    in rec {
      legacyPackages.${system} = import nixpkgs { inherit system overlays; };
      module.nixpkgs = { inherit config overlays; };
    };
}

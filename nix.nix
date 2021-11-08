# TODO https://github.com/Mic92/doctor-cluster-config/blob/master/configurations.nix#L25
# nix.nixPath = [
#   "home-manager=${home-manager}"
#   "nixpkgs=${nixpkgs}"
#   "nur=${nur}"
# ];

# nix.extraOptions = ''
#   flake-registry = ${flake-registry}/flake-registry.json
# '';

# nix.registry = {
#   home-manager.flake = home-manager;
#   nixpkgs.flake = nixpkgs;
#   nur.flake = nur;
# };

{ pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
    allowedUsers = [ "@wheel" ];
    extraOptions = ''
      # for flakes
      experimental-features = nix-command flakes ca-references
      # for direnv
      #keep-outputs = true
      #keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates     = "monthly";
      options   = "--delete-older-than 30d";
    };
    autoOptimiseStore  = true;
    optimise.automatic = true;
    # binaryCaches = [ "https://cache.nixos.org" "https://cache.mercury.com" ];
    # binaryCachePublicKeys = [ "cache.mercury.com:yhfFlgvqtv0cAxzflJ0aZW3mbulx4+5EOZm6k3oML+I=" ];
  };
}

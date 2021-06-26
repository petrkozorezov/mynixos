{ pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
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

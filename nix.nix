{ pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
    gc = {
      automatic = true;
      dates     = "daily";
      options   = "--delete-older-than 30d";
    };
    autoOptimiseStore  = true;
    optimise.automatic = true;
  };
}

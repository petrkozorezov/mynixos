{ pkgs, inputs, lib, ... }:
{
  nix = {
    package      = pkgs.nixFlakes;
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

    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=/etc/nixpkgs" ];
    requireSignedBinaryCaches = true;
  };

  environment.etc.nixpkgs.source = inputs.nixpkgs;
}

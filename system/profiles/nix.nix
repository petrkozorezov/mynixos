{ pkgs, deps, lib, ... }: {
  imports = [
    {
      # for eg `nix shel mynixos#hello`
      nix.registry.mynixos.flake = deps;
      # for eg `nix eval --impure --expr 'import <mynixos>'`
      nix.nixPath = [ "mynixos=/etc/mynixos" ];
      environment.etc.mynixos.source = deps;
    }
    {
      # exactly the nixpkgs version from which the system was built
      nix.registry.nixpkgs.flake = deps.inputs.nixpkgs;
      nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
      environment.etc.nixpkgs.source = deps.inputs.nixpkgs;
    }
  ];
  nix = {
    package      = pkgs.nixFlakes;
    allowedUsers = [ "@wheel" ];
    extraOptions = ''
      # for flakes
      experimental-features = nix-command flakes
      # for direnv
      #keep-outputs = true
      #keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };
    autoOptimiseStore  = true;
    optimise.automatic = true;

    requireSignedBinaryCaches = true;
  };
}

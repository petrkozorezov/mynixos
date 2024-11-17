{ pkgs, deps, lib, ... }: {
  imports = [
    {
      # for eg `nix shell mynixos#hello`
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
    package      = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };
    optimise.automatic = true;

    settings = {
      allowed-users       = [ "@wheel" ];
      require-sigs        = true;
      auto-optimise-store = true;
      substituters        = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };
}

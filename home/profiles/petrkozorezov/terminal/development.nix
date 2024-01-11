{ pkgs, deps, system, ... }:
{
  home = {
    packages = with pkgs; [
      gtypist
      pandoc

      cachix
      devenv
      gnumake
    ];
  };

  nix.settings = {
    substituters        = [ "https://devenv.cachix.org" ];
    trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  };
}

{ pkgs, lib, ... }:
{
  imports = [
    ../sss.nix
    ./desktop
    ./terminal
  ];

  home = {
    packages     = [ pkgs.test ]; # hm overlay is working
    stateVersion = lib.mkForce "20.09";
  };
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters        = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };
}

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
}

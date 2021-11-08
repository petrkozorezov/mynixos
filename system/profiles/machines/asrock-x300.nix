{ pkgs, ... }:
{
  imports = [
    ../nm-connections.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "21.05";
}

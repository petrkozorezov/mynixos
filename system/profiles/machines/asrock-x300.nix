{ pkgs, ... }:
{

  boot.kernelPackages = pkgs.linuxPackages_5_14;

  system.stateVersion = "21.05";
}

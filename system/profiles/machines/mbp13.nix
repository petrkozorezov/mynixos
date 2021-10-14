{ pkgs, ... }:
{

  boot.kernelPackages = pkgs.linuxPackages_5_13;

  system.stateVersion = "21.05";
}

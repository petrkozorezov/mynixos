{ pkgs, ... }:
{
  imports = [
    ../nm-connections.nix
    ../yubikey.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "21.05";
}

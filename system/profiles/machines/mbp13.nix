{ config, pkgs, ... }: {
  imports = [
    ../nm-connections.nix
    ../yubikey.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.etc.machine-id.text = "b285cdcc5b80442fa5cae227fb6423b6";

  system.stateVersion = "21.05";
}

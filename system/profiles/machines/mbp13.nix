{ config, pkgs, ... }: {
  imports = [
    ../nm-connections.nix
  ];
  # boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.etc.machine-id.text = builtins.hashString "sha1" config.networking.hostName;
  # environment.etc.machine-id.text = "b285cdcc5b80442fa5cae227fb6423b6";

  system.stateVersion = "21.05";
}

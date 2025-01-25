{ pkgs, ... }: {
  imports = [
    ../base.nix
    ../hardware/asrock-x300.nix
    ../workstation.nix

    ../nm-connections.nix
    ../yubikey.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "21.05";
}

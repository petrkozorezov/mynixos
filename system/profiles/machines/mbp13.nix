{ config, pkgs, ... }: {
  imports = [
    ../base.nix
    ../hardware/mbp13.nix
    ../workstation.nix

    ../nm-connections.nix
    ../yubikey.nix
    ../hardware/uhk.nix
    ../hardware/ledger.nix
  ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  environment.etc.machine-id.text = "b285cdcc5b80442fa5cae227fb6423b6";

  system.stateVersion = "21.05";
}

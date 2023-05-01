{ pkgs, ... }: {
  imports = [
    ../nm-connections.nix
    ../yubikey.nix
    ../hardware/uhk.nix
    ../hardware/ledger.nix
    ../livebook.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "21.05";
}

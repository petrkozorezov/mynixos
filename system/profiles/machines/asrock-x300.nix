{ pkgs, ... }: {
  imports = [
    ../base.nix
    ../hardware/asrock-x300.nix
    ../workstation.nix

    ../nm-connections.nix
    ../yubikey.nix
    ../mylivebook.nix
  ];

  system.stateVersion = "21.05";
}

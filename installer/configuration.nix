{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # TODO allow unfree

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # router does not support true

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile /etc/ssh/authorized_keys.d/root) ];

  networking.hostName = "nixos"; # Define your hostname.
}

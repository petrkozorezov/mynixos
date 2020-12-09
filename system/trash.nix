{ ... }:
{
  #system.autoUpgrade.enable = true;
  #extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  #services.syncthing = import /etc/nixos/syncthing.nix;
  # ???
  # users.groups = {
  #   plugdev = {};
  # };

}

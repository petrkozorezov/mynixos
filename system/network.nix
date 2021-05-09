{ ... }:
{
  networking = {
    hostName = "asrock-x300"; # FIXME
    networkmanager.enable = true;
    useDHCP = false;
  };
  users.users.petrkozorezov.extraGroups = [ "networkmanager" ];
}

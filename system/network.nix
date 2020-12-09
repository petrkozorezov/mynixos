{ ... }:
{
  networking = {
    hostName = "petrkozorezov-notebook";
    networkmanager.enable = true;
    useDHCP = false;
  };
  users.users.petrkozorezov.extraGroups = [ "networkmanager" ];
}
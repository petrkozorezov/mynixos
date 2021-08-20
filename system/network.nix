{ ... }:
{
  networking = {
    #hostName = "hostname";
    networkmanager.enable = true;
    useDHCP = false;
  };
  users.users.petrkozorezov.extraGroups = [ "networkmanager" ];
}

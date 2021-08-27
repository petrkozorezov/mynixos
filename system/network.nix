{ ... }:
{
  networking = {
    #hostName = "hostname";
    networkmanager.enable = true;
    firewall.checkReversePath = false; # to allow send all traffic through wg
    useDHCP = false;
  };
  users.users.petrkozorezov.extraGroups = [ "networkmanager" ];
}

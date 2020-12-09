{ ... }:
{
  virtualisation.virtualbox.host.enable = true;
  users.users.petrkozorezov.extraGroups  = [ "vboxusers" ];
}
{ ... }:
{
  programs.wireshark.enable = false;
  users.users.petrkozorezov.extraGroups  = [ "wireshark" ];
}
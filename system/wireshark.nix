{ pkgs, ... }:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.petrkozorezov.extraGroups  = [ "wireshark" ];
}

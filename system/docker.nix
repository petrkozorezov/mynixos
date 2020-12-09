{ ... }:
{
  virtualisation.docker.enable = true;
  users.users.petrkozorezov.extraGroups  = [ "docker" ];
}

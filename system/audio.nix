{ pkgs, ... }:
{
  hardware.pulseaudio = {
    enable       = true;
    support32Bit = true;
    package      = pkgs.pulseaudioFull;
  };
  sound.enable = true;
  users.users.petrkozorezov.extraGroups  = [ "audio" ];
}

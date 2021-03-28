{ pkgs, ... }:
{
  sound.enable = true;

  hardware.pulseaudio = {
    enable       = true;
    # enable       = false;
    support32Bit = true;
    package      = pkgs.pulseaudioFull;
  };

  users.users.petrkozorezov.extraGroups  = [ "audio" ];
}

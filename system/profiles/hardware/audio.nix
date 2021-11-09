{ pkgs, ... }:
{
  # audio
  sound.enable = true;
  hardware.pulseaudio = {
    enable       = true;
    support32Bit = true;
    package      = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
}

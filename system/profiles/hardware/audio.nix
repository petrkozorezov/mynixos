{ pkgs, ... }:
let
  pipewirePulseEnable = true;
in {
  hardware.pulseaudio = {
    enable       = !pipewirePulseEnable;
    support32Bit = true;
    package      = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  services.pipewire = {
    enable = pipewirePulseEnable;
    jack.enable = true;
    alsa   = {
      enable       = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}

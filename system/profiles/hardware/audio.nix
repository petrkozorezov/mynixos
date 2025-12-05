{ config, pkgs, ... }: {
  services.pulseaudio = {
    enable       = !config.services.pipewire.enable;
    support32Bit = true;
    package      = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa   = {
      enable       = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}

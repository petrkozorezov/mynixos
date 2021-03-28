{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa   = {
      enable       = true;
      support32Bit = true;
    };
    # pulse.enable = true;
  };

  xdg = {
    autostart.enable = true;
    portal = {
      enable       = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      gtkUsePortal = true;
    };
  };
}

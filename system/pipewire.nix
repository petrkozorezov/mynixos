{ pkgs, ... }:
{
  services.pipewire.enable = true;

  xdg.portal = {
    enable       = true;
    gtkUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
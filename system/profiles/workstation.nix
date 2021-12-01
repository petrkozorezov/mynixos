{ pkgs, config, ... }:
{
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # wireshark
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # vbox
  virtualisation.virtualbox.host.enable = true;

  # docker
  virtualisation.docker.enable = true;

  # steam
  # TODO move to home profile
  programs.steam.enable = true;

  # security
  services.pcscd.enable   = true;
  programs.ssh.startAgent = false;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.pam.services.swaylock = {};

  # networking
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    useDHCP = false;
  };

  # pipewire
  services.pipewire = {
    enable = true;
    alsa   = {
      enable       = false;
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

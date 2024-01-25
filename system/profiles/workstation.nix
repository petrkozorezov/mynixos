{ pkgs, config, ... }:
{
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # I don't know why, so maybe later...
  # boot.plymouth.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd sway";
  };

  # TODO to home profile
  fonts = {
    packages = with pkgs; [
      hack-font
    ];
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "Hack" ];
    };
  };

  # wireshark
  programs.wireshark = {
    enable  = true;
    package = pkgs.wireshark;
  };

  # vbox
  virtualisation.virtualbox.host.enable = false;

  # docker
  virtualisation.docker.enable = true;

  # steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall      = true;
    dedicatedServer.openFirewall = true;
  };
  # broken
  programs.gamescope = {
    enable     = true;
    # capSysNice = true; # is no working
  };

  # security
  services.pcscd.enable   = true;
  programs.ssh.startAgent = false;
  services.udev.packages  = [ pkgs.yubikey-personalization ];
  security.pam.services.swaylock = {};

  # networking
  networking = {
    networkmanager = {
      enable       = true;
      wifi.backend = "iwd";
    };
    useDHCP = false;
  };

  # for pipewire
  xdg = {
    autostart.enable = true;
    portal = {
      enable       = true;
      wlr.enable   = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };
  };

  documentation.man.enable = true;
  services.journald.extraConfig = "SystemMaxUse=1G";

  hardware.ledger.enable = true;
  hardware.keyboard.uhk.enable = true;
}

{ pkgs, config, lib, ... }:
{
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # I don't know why, so maybe later...
  # boot.plymouth.enable = true;
  services.greetd = let
    startSway = pkgs.writeScript "start-sway" ''
      USER_NAME=$(whoami)
      USER_SHELL=$(getent passwd "$USER_NAME" | cut -d: -f7)
      exec "$USER_SHELL" -c 'exec sway'
      '';
  in {
    enable = true;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${startSway}";
  };
  services.udisks2.enable = true;

  # TODO use stylix
  fonts = {
    packages = with pkgs; [ pkgs.nerd-fonts.jetbrains-mono ];
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };

  # for gtk configuration
  programs.dconf.enable = true;

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
    enable = true;
    # capSysNice = true; # is not working
  };

  # security
  services.pcscd.enable   = true;
  programs.ssh.startAgent = false;
  services.udev.packages  = [ pkgs.yubikey-personalization ];

  security.pam.services.swaylock = {};

  security.polkit.enable = true;
  security.rtkit.enable  = true;

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

  documentation.man.enable = lib.mkForce true;
  services.journald.extraConfig = "SystemMaxUse=1G";

  hardware.ledger.enable = true;
  hardware.keyboard.uhk.enable = true;

  # syncthing
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 21027 22000 ];
  };
}

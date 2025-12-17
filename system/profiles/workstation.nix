{ pkgs, config, lib, ... }: let
  # TODO move to user
  startSteam = pkgs.writeShellScriptBin "start-steam" ''
    export XKB_DEFAULT_LAYOUT="us,ru"
    export XKB_DEFAULT_VARIANT=","
    export XKB_DEFAULT_OPTIONS="grp:lctrl_lwin_rctrl_menu"
    exec dbus-run-session -- ${pkgs.kdePackages.kwin}/bin/kwin_wayland --xwayland --exit-with-session="${config.programs.steam.package}/bin/steam $*"
  '';
  startSway = pkgs.writeShellScriptBin "start-sway" ''
    export XKB_DEFAULT_LAYOUT="${config.services.xserver.xkb.layout}"
    export XKB_DEFAULT_VARIANT="${config.services.xserver.xkb.variant}"
    export XKB_DEFAULT_OPTIONS="${config.services.xserver.xkb.options}"
    exec sh -c 'dbus-run-session -- ${pkgs.sway}/bin/sway --unsupported-gpu "$@" >> "$XDG_RUNTIME_DIR/sway-$(date +%s).log" 2>&1' _ "$@"
  '';
  startPlasmaWayland = pkgs.writeShellScriptBin "start-plasma" ''
    exec dbus-run-session -- startplasma-wayland $*
  '';
in {

  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # I don't know why, so maybe later...
  # boot.plymouth.enable = true;

  services.udisks2.enable = true;

  environment.systemPackages = [
    startSteam
    startSway
    startPlasmaWayland
  ];

  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout  = "us,ru";
    variant = "dvp,mac";
    options = "grp:lctrl_lwin_rctrl_menu";
  };

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

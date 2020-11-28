# TODO: cleanup /usr/local/share/Geolite-city/GeoLite2-City.mmdb

{ config, pkgs, options, ... }:

let
  overlays = /etc/nixos/overlay;
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio  = true;
    };
  };

  #system.stateVersion = "20.03";

  boot = {
    kernelPackages                = pkgs.linuxPackages_5_8;
    kernelParams                  = [ ];
    kernelModules                 = [ "iwlwifi" ];
    #blacklistedKernelModules      = [ "nouveau" ];
    initrd.availableKernelModules = [ "battery" ];
    initrd.kernelModules          = [ "battery" ];
    cleanTmpDir                   = true;
    loader = {
      systemd-boot.enable      = true;
      timeout                  = 1;
      efi.canTouchEfiVariables = true;
      #systemd-boot.consoleMode = "max";
    };
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
    #extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  };

  networking = {
    hostName = "petrkozorezov-notebook";
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable  = true;
    pulseaudio = {
      enable       = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package      = pkgs.pulseaudioFull;
    };
    opengl = {
      enable          = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    cpu.intel.updateMicrocode = true;
  };
  powerManagement.enable = true;
  sound.enable           = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
   font       = "iso01-12x22";
   keyMap     = "dvp";
   earlySetup = true;
   #useXkbConfig
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # TODO move to home-manager
  fonts.fonts = with pkgs; [
    powerline-fonts
    font-awesome
    nerdfonts
    hack-font
  ];

  environment.systemPackages = with pkgs; [
    #undervolt
    lm_sensors
    pmount # (?)
    nix-index

    # pipewire_0_2
    # xdg-desktop-portal
    # xdg-desktop-portal-wlr
  ];

  programs = {
    light.enable      = true; # backlight control
    vim.defaultEditor = true;
    ssh.startAgent    = true;
    #wireshark = {
    #  enable  = true;
    #  package = pkgs.wireshark;
    #};
  };

  services = {
    #openssh.enable     = true;
    timesyncd.enable   = true;
    ntp.enable         = false;
    printing.enable    = true;
    blueman.enable     = true;
    tlp.enable         = true;
    upower.enable      = true;
    #fwupd.enable       = true;
    throttled.enable   = true;
    undervolt = {
      enable         = true;
      coreOffset     = -150;
      gpuOffset      = -150;
      uncoreOffset   = -150;
      analogioOffset = -100;
    };
    logind = {
      extraConfig =
        ''
          IdleAction=ingore # TODO suspend
          #HandlePowerKey=ignore
        '';
       lidSwitch              = "suspend";
       lidSwitchExternalPower = "suspend";
       lidSwitchDocked        = "suspend";
    };
    # flatpak.enable  = true;
    # pipewire.enable = true;
    # for UHK
    # udev = {
    #   extraRules = ''
    #     SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
    #     SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
    #     KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
    #   '';
    # };
    udev = {
      extraRules = ''
        # Rule for all ZSA keyboards
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
        # Rule for the Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
        # Rule for the Ergodox EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
        # Rule for the Planck EZ
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"      '';
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   gtkUsePortal = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-wlr
  #   ];
  # };

  security.polkit.enable = true;

  # for swaylock
  security.pam.services.swaylock = {};

  users.users.petrkozorezov = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "docker" "audio" "video" "networkmanager" "vboxusers" "wireshark" "plugdev" ];
    shell        = pkgs.zsh;
  };

  users.groups = {
    plugdev = {};
  };

  #system.autoUpgrade.enable = true;

  # dev
  virtualisation = {
    docker.enable          = true;
    virtualbox.host.enable = true;
  };

  # services.syncthing = import /etc/nixos/syncthing.nix;
}

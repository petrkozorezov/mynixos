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

  nix.nixPath =
    options.nix.nixPath.default ++
    [ "nixpkgs-overlays=${overlays}" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio  = true;
    };
    overlays = [ (import overlays) ];
  };

  system.stateVersion = "20.03";

  boot = {
    kernelParams = [ ];
    kernelModules = [ "iwlwifi" ];
    #blacklistedKernelModules = [ "nouveau" ];
    initrd.availableKernelModules = [ "battery" ];
    initrd.kernelModules = [ "battery" ];
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      timeout = 1;
      efi.canTouchEfiVariables = true;
      #systemd-boot.consoleMode = "max";
    };
    extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
  };

  networking = {
    hostName = "petrkozorezov-macbook";
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
    cpu.intel.updateMicrocode = true;
  };
  powerManagement.enable = true;
  sound.enable  = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
   font = "iso01-12x22";
   keyMap = "dvp";
   earlySetup = true;
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
    undervolt
    lm_sensors
    pmount # (?)
    nix-index
    #nixops
    hey
  ];

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [];
      extraSessionCommands =
        ''
          export SDL_VIDEODRIVER=wayland
          # needs qt5.qtwayland in systemPackages
          export QT_QPA_PLATFORM=wayland
          export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
          # Fix for some Java AWT applications (e.g. Android Studio),
          # use this if they aren't displayed properly:
          export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };
    light.enable      = true; # backlight control
    vim.defaultEditor = true;
    ssh.startAgent    = true;
    wireshark = {
      enable  = true;
      package = pkgs.wireshark;
    };
  };

  services = {
    #openssh.enable     = true;
    ntp.enable         = true;
    printing.enable    = true;
    blueman.enable     = true;
    tlp.enable         = true;
    upower.enable      = true;
    #fwupd.enable       = true;
    throttled.enable   = true;
    undervolt = {
      enable         = true;
      coreOffset     = "-150";
      gpuOffset      = "-150";
      uncoreOffset   = "-150";
      analogioOffset = "-100";
    };
    logind.extraConfig =
      ''
        IdleAction=ingore # TODO suspend
        HandlePowerKey=ignore
      '';

    xserver = {
      enable  = true;
      autorun = false;
      displayManager.sddm.enable   = true;
      desktopManager.gnome3.enable = true;
    };
  };

  users.users.petrkozorezov = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" "networkmanager" "vboxusers" "wireshark" ];
    shell = pkgs.zsh;
  };

  system.autoUpgrade.enable = true;

  # dev
  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  # services.syncthing = import /etc/nixos/syncthing.nix;
}

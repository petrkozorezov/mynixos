# TODO: cleanup /usr/local/share/Geolite-city/GeoLite2-City.mmdb

{ config, pkgs, options, ... }:

let
  # 17 Nov 2019
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/cb895499a77711c121aa978efb0588c28e68f9e4.tar.gz;
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
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [ (import overlays) ];
  };


  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelParams = [ ];
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      timeout = 1;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "petrkozorezov-macbook";
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  services.tlp.enable = true;
  services.upower.enable = true;

  hardware = {
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
  sound.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont   = "iso01-12x22";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  #console = {
  #  font = "iso01-12x22";
  #  keyMap = "us";
  #};


  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  fonts.fonts = with pkgs; [
    powerline-fonts
    font-awesome
    nerdfonts
    hack-font
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    # shell


    # sway
    networkmanager_dmenu
    grim slurp          # screenshoter
    mako notify-desktop # notifications
    unstable.clipman wl-clipboard # clipboard (wl-copy wl-paste)
    unstable.ydotool    # gui automation tool
    waypipe             # wayland over ssh
    rofi                # unstable.wofi # launcher (wofi has a shit-like fuzzy search)
    unstable.wob        # volume control overlay
    wev                 # W events debugging tool
    networkmanager_vpnc
    networkmanager_l2tp

    # tools
    unstable.python37Packages.glances

    pmount
    nix-index
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.blueman.enable = true;

  programs = {
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        xwayland
        dmenu
        unstable.waybar
        networkmanagerapplet
        pavucontrol
        wallutils # TODO use it
      ];
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
    light.enable = true; # backlight control
    vim.defaultEditor = true;
    ssh.startAgent = true;
  };

  services = {
    ntp.enable = true;
    logind.extraConfig =
      ''
        IdleAction=ingore # TODO suspend
        HandlePowerKey=ignore
      '';
  };

  users.users.petrkozorezov = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  #system.autoUpgrade.enable = true;

  # dev
  virtualisation.docker.enable = true;
}

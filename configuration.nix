# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
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
      timeout = 2;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "petrkozorezov-macbook"; # Define your hostname.
    networkmanager.enable = true;
    connman = {
      enable = false;
      extraFlags = [ "-d" ];
    };
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.


    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  services.tlp.enable = true;
  services.upower.enable = true;

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
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
    consoleFont = "iso01-12x22";
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
    #zsh
    elvish
    kitty
    rxvt_unicode

    # browser, mail, ...
    firefox-wayland
    chromium
    qutebrowser
    # surf
    #thunderbird
    gnome3.geary
    tdesktop
    slack
    calibre
    libreoffice
    nixnote2

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

    # editors
    vim
    sublime3
    atom

    # langs
    erlangR22
    ghc stack
    idris

    # tools
    git gitAndTools.hub
    gdb
    killall
    bc
    htop python37Packages.glances
    curl wget
    mc ranger
    neofetch
    docker-compose
    sloccount
    jq
    qcachegrind
    graphviz
    pulsemixer pamixer
    nix-index

    veracrypt
    dropbox-cli
    keepassxc
    #keepass-keefox # TODO try it
 
    #cmst
    networkmanager_vpnc
    networkmanager_l2tp
    #networkmanagerapplet
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
  # services.printing.enable = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [ swaylock swayidle xwayland dmenu i3status-rust];
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
  programs.light.enable = true; # backlight control
  programs.vim.defaultEditor = true;
  

  services.xserver = {
    enable = true;

    #videoDrivers = [ "nv" ];
    layout = "us";
    autorun = false;

    autoRepeatDelay = 200;
    autoRepeatInterval = 40;

    # Enable touchpad support.
    libinput = {
      #enable = true;
      naturalScrolling = true;
      additionalOptions = 
	''
          Option "Tapping" "true"
          Option "TappingDrag" "true" 
        '';
    };

    displayManager = {
      sddm.enable = true;
    };

    desktopManager = {
      gnome3.enable = true;
    };

    windowManager = {
      i3.enable = true;
    };
  };

  #users.defaultShell = "zsh"
  users.users.petrkozorezov = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs = {
    ssh.startAgent = true;
    zsh = {
      enable  = true;
      ohMyZsh = {
        enable  = true;
        plugins = [ "git" ];
        theme   = "amuse";
      };
    };
  };

  #system.autoUpgrade.enable = true;

  # dev
  virtualisation.docker.enable = true;
}


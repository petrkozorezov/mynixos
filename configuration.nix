{ pkgs, ... }:
{
  imports =
    [
      ./hardware/default.nix
      ./system/default.nix
    ];

  nixpkgs = (import ./config.nix);

  boot = {
    kernelPackages = pkgs.linuxPackages_5_8;
    cleanTmpDir    = true;
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
  };

  networking = {
    hostName = "petrkozorezov-notebook";
    networkmanager.enable = true;
    useDHCP = false;
  };

  hardware = {
    bluetooth.enable  = true;
    pulseaudio = {
      # enable       = false;
      enable       = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package      = pkgs.pulseaudioFull;
    };
    opengl = {
      enable          = true;
      # for Steam
      #driSupport32Bit = true;
      #extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };

  };
  sound.enable = true;

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
  ];

  programs = {
    vim.defaultEditor = true;
    ssh.startAgent    = true;
    #wireshark = {
    #  enable  = true;
    #  package = pkgs.wireshark;
    #};
  };

  services = {
    #openssh.enable     = true;
    #timesyncd.enable   = true;
    ntp.enable         = false;
    printing.enable    = true;
    blueman.enable     = true;
    tlp.enable         = true;
    upower.enable      = true;
    #fwupd.enable       = true;
  };

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

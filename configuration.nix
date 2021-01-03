{ pkgs, ... }:
{
  imports =
    [
      ./nix.nix
      ./system
    ];

  nixpkgs = (import ./config.nix);

  boot = {
    kernelPackages = pkgs.linuxPackages_5_8;
    cleanTmpDir    = true;
    kernel.sysctl."fs.inotify.max_user_watches" = 524288;
  };

  hardware.opengl.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
   font       = "iso01-12x22";
   keyMap     = "dvp";
   earlySetup = true;
   #useXkbConfig (??)
  };


  time.timeZone = "Europe/Moscow";

  fonts.fonts = with pkgs; [
    powerline-fonts
    font-awesome
    nerdfonts
    hack-font
  ];

  environment.systemPackages = [ pkgs.overlay-sys-test ];
  environment.pathsToLink = [ "/share/zsh" ]; # for programs.zsh.enableCompletion

  programs.vim.defaultEditor = true;

  services = {
    #openssh.enable     = true;
    #timesyncd.enable   = true;
    #fwupd.enable       = true;
    ntp.enable         = false;
    printing.enable    = true;
    tlp.enable         = true;
    upower.enable      = true;
  };

  users.users.petrkozorezov = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "audio" "video" "plugdev" ];
    shell        = pkgs.zsh;
  };
}

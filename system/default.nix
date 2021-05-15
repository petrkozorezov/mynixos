{ pkgs, config, ... }:
{
  imports =
    [
      ./audio.nix
      ./loader.nix
      ./docker.nix
      ./network.nix
      ./pipewire.nix
      ./security.nix
      ./steam.nix
      ./uhk.nix
      ./vbox.nix
      ./wireshark.nix
      ./zsa-keyboards.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_11;
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
#    nerdfonts
#    (nerdfonts.override { fonts = ["Iosevka"]; })
    hack-font
    jetbrains-mono
  ];

  environment.systemPackages = [ pkgs.overlay-sys-test ];
  environment.pathsToLink    = [ "/share/zsh" ]; # for programs.zsh.enableCompletion

  programs.vim.defaultEditor = true;

  services = {
    openssh.enable     = true;
    #timesyncd.enable   = true;
    #fwupd.enable       = true;
    ntp.enable         = false;
    printing.enable    = true;
    tlp.enable         = true;
    upower.enable      = true;
  };

  programs = {
    uhk-agent.enable = true;
  };

  users = {
    mutableUsers        = false;
    users = let
      userCfg = config.zoo.secrets.users.petrkozorezov;
    in {
      petrkozorezov = {
        isNormalUser                = true;
        description                 = "Petr Kozorezov";
        extraGroups                 = [ "wheel" "audio" "video" "plugdev" ];
        shell                       = pkgs.zsh;
        hashedPassword              = userCfg.hashedPassword;
        openssh.authorizedKeys.keys = [ userCfg.authPublicKey ];
      };
      root.openssh.authorizedKeys.keys = [ userCfg.authPublicKey ];
    };
  };

  system.stateVersion = "21.05";
}

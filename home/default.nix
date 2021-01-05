{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./base.nix
    ./desktop.nix
    ./development.nix
    ./dropbox.nix
    ./firefox.nix
    ./git.nix
    ./htop.nix
    ./mako.nix
    ./rofi.nix
    ./security.nix
    ./ssh.nix
    ./subl.nix
    ./sway.nix
    ./waybar.nix
    ./zathura.nix
    ./zsh.nix
  ];

  home.sessionVariables = {
    EDITOR   = "vim"; # subl --wait
    BROWSER  = "firefox";
    TERMINAL = "alacritty";
  };
  programs.home-manager.enable = true;


  home.packages = [ pkgs.overlay-hm-test ];
  # user = rec {
  #   login     = "petr.kozorezov";
  #   email     = "${login}@gmail.com";
  #   firstname = "Petr";
  #   lastname  = "Kozorezov";
  #   fullname  = "${firstname} ${lastname}";
  #   gpgKey    = email;
  #   font      = "Hack";
  #   defaultPrograms = {
  #     editor   = "vim";
  #     browser  = "firefox";
  #     terminal = "alacritty";
  #     shell    = "zsh";
  #   };
  # };

}

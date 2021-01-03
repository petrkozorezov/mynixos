{ pkgs, ... }:
{

  imports = [
    ./home
  ];

  home.sessionVariables = {
    EDITOR   = "vim";
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

#
# TODO:
#  - rofi
#  - secrets
#  - https://nix-community.github.io/home-manager/#sec-install-nixos-module
#
{ ... }:
{

  imports = [
    ./home/default.nix
  ];

  nixpkgs = (import ./config.nix);

  home.sessionVariables = {
    EDITOR   = "vim";
    BROWSER  = "firefox";
    TERMINAL = "alacritty";
  };
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.


  # user = rec {
  #   login     = "petr.kozorezov";
  #   email     = "${login}@gmail.com";
  #   firstname = "Petr";
  #   lastname  = "Kozorezov";
  #   fullname  = "${firstname} ${lastname}";
  #   gpgKey    = "EF2A246DDE509B0C";
  #   font      = "Hack";
  #   defaultPrograms = {
  #     editor   = "vim";
  #     browser  = "firefox";
  #     terminal = "alacritty";
  #     shell    = "zsh";
  #   };
  # };

}

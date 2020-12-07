#
# TODO:
#  - rofi
#  - zathura
#  - fonts
#  - refactor imports
#  - secrets
#  - https://nix-community.github.io/home-manager/#sec-install-nixos-module
#  - services.dropbox
#
args@{ config, pkgs, ... }:
let
  # # 17 Nov 2019
  # unstableTarball =
  #   fetchTarball
  #     https://github.com/NixOS/nixpkgs-channels/archive/cb895499a77711c121aa978efb0588c28e68f9e4.tar.gz;
  nur_repo = builtins.fetchTarball {
    url    = "https://github.com/nix-community/NUR/archive/1a65739939b6d5e5f3b40f9fc51f4362720478c1.tar.gz";
    sha256 = "1r32qv3kfq4c3gc5cnrbscghxp891sdn6i042kd4msx133iawp5q";
  };
  settings   = import ./home/settings.nix;
  importFile = file-name: (import file-name) (args // { inherit settings; });
in
{

  imports = [ ./home/i3.nix ./home/sway.nix ];

  nixpkgs = {
    config = {
      # packageOverrides = pkgs: {
      #   unstable = import unstableTarball {
      #     config = config.nixpkgs.config;
      #   };
      # };
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (nur_repo) { inherit pkgs; };
      };
      permittedInsecurePackages = [
        "openssl-1.0.2u"
        "python2.7-cryptography-2.9.2"
      ];
    };
  };

  home = {
    sessionVariables = {
      EDITOR   = "vim";
      BROWSER  = "firefox";
      TERMINAL = "alacritty";
    };
    packages = importFile ./home/packages.nix;
  };

  programs = {
    home-manager.enable = true; # Let Home Manager install and manage itself.
    git       = importFile ./home/git.nix      ;
    zsh       = importFile ./home/zsh.nix      ;
    ssh       = importFile ./home/ssh.nix      ;
    htop      = importFile ./home/htop.nix     ;
    alacritty = importFile ./home/alacritty.nix;
    firefox   = importFile ./home/firefox.nix  ;
    waybar    = importFile ./home/waybar.nix   ;
    mako      = importFile ./home/mako.nix     ;
    zathura   = importFile ./home/zathura.nix  ;
  };


  services = {
    gpg-agent.enable = true;
    # xcape = {
    #   enable = false;
    #   timeout = 500;
    # };
    # syncthing = {
    #   enable = true;
    #   tray   = true;
    # };
  };
}


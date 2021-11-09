{ pkgs, lib, ... }:
{
  imports = [
    ./base.nix
    ./browser.nix
    ./desktop.nix
    ./development.nix
    ./dropbox.nix
    ./editor.nix
    ./fonts.nix
    ./games.nix
    ./git.nix
    ./htop.nix
    ./mako.nix
    ./rofi.nix
    ./security.nix
    ./shell.nix
    ./ssh.nix
    ./subl.nix
    ./sway.nix
    ./terminal.nix
    ./waybar.nix
    ./xdg.nix
    ./zathura.nix
  ];

  programs.home-manager.enable = true;
  home = {
    packages     = [ pkgs.overlay-hm-test ];
    stateVersion = lib.mkForce "20.09";
  };
}

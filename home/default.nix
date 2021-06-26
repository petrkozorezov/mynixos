{ pkgs, nur, ... }:
let
  nixpkgs = (import ../nixpkgs.nix);
in {
  imports = [
    ../secrets

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
    ./zathura.nix
  ];

  nixpkgs = nixpkgs // { overlays = nixpkgs.overlays ++ [ nur.overlay ]; };
  programs.home-manager.enable = true;
  home = {
    packages     = [ pkgs.overlay-hm-test ];
    # error: The option `home.stateVersion' has conflicting definition values:
    #        - In `/nix/store/bv3awswkczn0611y70pdjbqxmn8q6lmd-source/home': "20.03"
    #        - In `<unknown-file>': "20.09"
    #stateVersion = "20.03";
  };
}

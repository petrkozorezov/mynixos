{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bc
    killall
    glances
    curl wget
    ranger
    jq
    gnupg
    pciutils
    unzip
    vim
    tree

    pmount # (?)
    lm_sensors
    nix-index

    pulsemixer pamixer

  ];
}
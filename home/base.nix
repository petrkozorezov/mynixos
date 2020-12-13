{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bc
    killall
    bc
    glances
    curl wget
    ranger
    jq
    gnupg
    pciutils
    unzip
    fasd
    vim

    pmount # (?)
    lm_sensors
    nix-index

    pulsemixer pamixer

  ];
}
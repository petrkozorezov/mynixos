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
    usbutils
    unzip
    vim
    tree
    bind.dnsutils

    pmount # (?)
    lm_sensors
    nix-index

    pulsemixer pamixer

  ];
}

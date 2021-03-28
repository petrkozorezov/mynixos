{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bc
    killall
    glances
    curl wget
    ranger mc
    jq
    gnupg
    unzip
    vim
    tree

    # hardware
    pciutils
    usbutils

    # admin
    bind.dnsutils
    ldns

    pmount # (?)
    lm_sensors
    nix-index

    pulsemixer pamixer
  ];
}

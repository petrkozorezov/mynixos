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

    # hardware
    pciutils
    usbutils

    # admin
    bind.dnsutils
    ldns
    lsof

    pmount # (?)
    lm_sensors
    nix-index

    pulsemixer pamixer
  ];
}

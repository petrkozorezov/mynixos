{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # utils
    bc
    killall
    curl wget
    ranger mc
    # nnn
    gnupg
    unzip
    vim
    # rlwrap
    # asciinema
    # ruplacer
    pandoc
    qrencode

    # hardware
    pciutils
    usbutils

    # admin
    bind.dnsutils
    ldns
    lsof

    # pmount # (?)
    lm_sensors
    nix-index

    # sound
    pulsemixer pamixer

    # obsidian
    # zotero
  ];
}
